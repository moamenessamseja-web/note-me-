import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pointycastle/export.dart' as pc;

import '../models/note.dart';
import 'app_state.dart';

/// VaultService manages encrypted notes using AES/CBC via pointycastle.
///
/// Key derivation uses PBKDF2 (SHA-256, 100,000 iterations) from a fixed salt.
/// Each note is encrypted as a full JSON object (title + content together).
class VaultService {
  VaultService._();
  static final VaultService instance = VaultService._();

  static const String _kVaultNotes = 'vault_notes_v1';
  static const String _kVaultPwd = 'vault_password_v1';

  String? _password;
  bool _locked = true;
  SharedPreferences? _prefs;

  static Future<void> init() async {
    try {
      instance._prefs = await SharedPreferences.getInstance();
    } catch (_) {
      instance._prefs = null;
    }
  }

  bool hasPassword() {
    final prefs = _prefs;
    return prefs != null && prefs.containsKey(_kVaultPwd);
  }

  static Future<void> setPassword(String password) async {
    final prefs = instance._prefs;
    if (prefs == null) throw StateError('VaultService not initialized');
    final h = _hash(password);
    await prefs.setString(_kVaultPwd, h);
    instance._password = password;
    instance._locked = false;
  }

  static Future<bool> unlock(String password) async {
    final prefs = instance._prefs;
    if (prefs == null) return false;
    if (!prefs.containsKey(_kVaultPwd)) return false;
    final stored = prefs.getString(_kVaultPwd) ?? '';
    if (_hash(password) != stored) return false;
    instance._password = password;
    instance._locked = false;
    return true;
  }

  static Future<void> lock() async {
    instance._password = null;
    instance._locked = true;
  }

  bool get isLocked => _locked;

  static List<Note> vaultNotes() {
    final prefs = instance._prefs;
    if (prefs == null || instance._locked || instance._password == null) {
      return const <Note>[];
    }
    final raw = prefs.getStringList(_kVaultNotes) ?? const <String>[];
    final out = <Note>[];
    for (final s in raw) {
      try {
        final decrypted = _decryptString(s, instance._password!);
        final j = jsonDecode(decrypted) as Map<String, dynamic>;
        out.add(Note.fromJson(j));
      } catch (_) {
        // Skip corrupt entries.
      }
    }
    return out;
  }

  static Future<void> saveVaultNote(Note note) async {
    final prefs = instance._prefs;
    if (prefs == null || instance._locked || instance._password == null) {
      throw StateError('الخزنة مغلقة');
    }
    final existing = vaultNotes()..removeWhere((n) => n.id == note.id);
    existing.add(note);
    final enc = existing
        .map((n) => _encryptString(jsonEncode(n.toJson()), instance._password!))
        .toList();
    await prefs.setStringList(_kVaultNotes, enc);
    AppState.instance.notify();
  }

  static Future<void> deleteVaultNote(String id) async {
    final prefs = instance._prefs;
    if (prefs == null || instance._locked || instance._password == null) {
      throw StateError('الخزنة مغلقة');
    }
    final existing = vaultNotes()..removeWhere((n) => n.id == id);
    final enc = existing
        .map((n) => _encryptString(jsonEncode(n.toJson()), instance._password!))
        .toList();
    await prefs.setStringList(_kVaultNotes, enc);
    AppState.instance.notify();
  }

  static Future<void> clearVault() async {
    final prefs = instance._prefs;
    if (prefs == null) throw StateError('التخزين غير جاهز');
    await prefs.remove(_kVaultNotes);
  }

  // ════════════════════════════════════════════════════════════════
  // CRYPTO HELPERS (AES/CBC/256 + PBKDF2 via pointycastle)
  // ════════════════════════════════════════════════════════════════

  static Uint8List _deriveKey(String password) {
    const salt = 'note-me-vault-salt-v1';
    final derivator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
    derivator.init(pc.Pbkdf2Parameters(utf8.encode(salt), 100000, 32));
    return derivator.process(utf8.encode(password));
  }

  static String _encryptString(String plain, String password) {
    final key = _deriveKey(password);
    // Generate random IV
    final iv = Uint8List.fromList(
      List.generate(16, (_) => (math.Random().nextDouble() * 256).toInt()),
    );

    // AES/CBC encryption
    final cipher = pc.PaddedBlockCipher('AES/CBC/PKCS7');
    cipher.init(true, pc.ParametersWithIV(pc.KeyParameter(key), iv));
    final plainBytes = utf8.encode(plain);
    final encrypted = cipher.process(plainBytes);

    // Combine IV + ciphertext, encode as base64
    final combined = Uint8List(iv.length + encrypted.length);
    combined.setAll(0, iv);
    combined.setAll(iv.length, encrypted);
    return base64.encode(combined);
  }

  static String _decryptString(String encB64, String password) {
    final combined = base64.decode(encB64);
    final iv = Uint8List.fromList(combined.sublist(0, 16));
    final ciphertext = Uint8List.fromList(combined.sublist(16));

    final key = _deriveKey(password);
    final cipher = pc.PaddedBlockCipher('AES/CBC/PKCS7');
    cipher.init(false, pc.ParametersWithIV(pc.KeyParameter(key), iv));
    final decrypted = cipher.process(ciphertext);
    return utf8.decode(decrypted);
  }

  static String _hash(String password) {
    final derivator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
    const salt = 'note-me-vault-salt-v1';
    derivator.init(pc.Pbkdf2Parameters(utf8.encode(salt), 100000, 32));
    final out = derivator.process(utf8.encode(password));
    return base64.encode(out);
  }

  static Future<void> wipe() async {
    instance._password = null;
    instance._locked = true;
  }
}
