import 'dart:convert';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../models/note.dart';
import 'app_state.dart';

/// VaultService manages encrypted notes using AES/CBC via the `encrypt` package.
///
/// Key derivation uses PBKDF2 (SHA-256, 100,000 iterations) from a fixed salt.
/// Each note is encrypted as a full JSON object (title + content together),
/// fixing the web clone bug where only the body was encrypted.
class VaultService {
  VaultService._();
  static final VaultService instance = VaultService._();

  static const String _kVaultNotes = 'vault_notes_v1';
  static const String _kVaultPwd = 'vault_password_v1';

  /// The active vault password (only held in memory while unlocked).
  String? _password;
  bool _locked = true;

  /// The current SharedPreferences instance.
  SharedPreferences? _prefs;

  /// Initialize the vault service.
  static Future<void> init() async {
    try {
      instance._prefs = await SharedPreferences.getInstance();
    } catch (_) {
      instance._prefs = null;
    }
  }

  /// Is there a vault password set?
  bool hasPassword() {
    final prefs = _prefs;
    return prefs != null && prefs.containsKey(_kVaultPwd);
  }

  /// Set the vault password (first time setup).
  static Future<void> setPassword(String password) async {
    final prefs = instance._prefs;
    if (prefs == null) throw StateError('VaultService not initialized');
    final h = _hash(password);
    await prefs.setString(_kVaultPwd, h);
    instance._password = password;
    instance._locked = false;
  }

  /// Attempt to unlock the vault.
  /// Returns `true` on success, `false` otherwise.
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

  /// Lock the vault and wipe the password from memory.
  static Future<void> lock() async {
    instance._password = null;
    instance._locked = true;
  }

  /// Is the vault currently locked?
  bool get isLocked => _locked;

  /// List of vault notes (decrypted). Empty if locked or no password.
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

  /// Save a vault note (encrypts full note JSON).
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

  /// Delete a vault note.
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

  /// Clear all vault notes.
  static Future<void> clearVault() async {
    final prefs = instance._prefs;
    if (prefs == null) throw StateError('التخزين غير جاهز');
    await prefs.remove(_kVaultNotes);
  }

  // ════════════════════════════════════════════════════════════════
  // CRYPTO HELPERS (AES/CBC/256 + PBKDF2)
  // ════════════════════════════════════════════════════════════════

  /// Derive a 256-bit key from the password via PBKDF2/SHA-256.
  static encrypt.Key _deriveKey(String password) {
    final salt = utf8.encode('note-me-vault-salt-v1');
    final pbkdf = encrypt.PBKDF2(
      key: utf8.encode(password),
      salt: salt,
      iterations: 100000,
      mac: encrypt.HMAC(encrypt.SHA256(), utf8.encode(password)),
      keyLength: 32,
    );
    return encrypt.Key(pbkdf.key);
  }

  /// Encrypt a string — returns base64 of (IV + ciphertext).
  static String _encryptString(String plain, String password) {
    final key = _deriveKey(password);
    final iv = encrypt.IV(math.Random().nextBytes(16));
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plain, iv: iv);
    final combined = utf8.encode(iv.base64) + '\n' + utf8.encode(encrypted.base64);
    return base64.encode(utf8.encode(combined));
  }

  /// Decrypt a string (base64 of IV + ciphertext).
  static String _decryptString(String encB64, String password) {
    final combined = utf8.decode(base64.decode(encB64));
    final nl = combined.indexOf('\n');
    if (nl == -1) throw FormatException('divider missing');
    final ivB64 = combined.substring(0, nl);
    final ctB64 = combined.substring(nl + 1);
    final key = _deriveKey(password);
    final iv = encrypt.IV.fromBase64(ivB64);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    return encrypter.decrypt64(ctB64, iv: iv);
  }

  /// Hash the password (SHA-256) for local storage.
  static String _hash(String password) {
    final sha = encrypt.SHA256();
    final digest = sha.convert(utf8.encode(password)).bytes;
    return base64.encode(digest);
  }

  /// Wipe the password from memory.
  static Future<void> wipe() async {
    instance._password = null;
    instance._locked = true;
  }
}
