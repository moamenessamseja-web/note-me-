import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';
import '../models/category.dart';
import 'app_state.dart';
import 'app_error_service.dart';

/// التخزينمحلي (مربوطة في AppContext الأصلي).
///
/// كل شيء `static` — يُستدعى عبر `StorageService.instance.notes()` إلخ.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static late SharedPreferences _prefs;
  static bool _initialized = false;

  static const String notesKey = 'notes_v1';
  static const String categoriesKey = 'categories_v1';
  static const String seededKey = 'seeded_v1';

  static Future<void> _gate = Future<void>.value();

  static Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
    _gate = Future<void>.value();
  }

  static Future<T> _serialize<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _gate = _gate.then((_) async {
      try {
        completer.complete(await action());
      } catch (e, s) {
        completer.completeError(e, s);
      }
    });
    return completer.future;
  }

  static List<T> _read<T>(String key, T Function(Map<String, dynamic>) parse) {
    final raw = _prefs.getStringList(key) ?? const <String>[];
    final out = <T>[];
    var corrupt = 0;
    for (final s in raw) {
      try {
        final j = jsonDecode(s);
        if (j is Map) {
          out.add(parse(Map<String, dynamic>.from(j)));
        } else {
          corrupt++;
        }
      } catch (e) {
        corrupt++;
        AppErrorService.log('storage.read($key)', e);
      }
    }
    if (corrupt > 0) {
      AppErrorService.log(
        'storage.read($key)',
        'خططنا $corrupt سجلًا تالفًا من أصل ${raw.length}',
      );
    }
    return out;
  }

  static Future<void> _write<T>(String key, List<T> items,
      String Function(T) encode) async {
    bool ok;
    try {
      ok = await _prefs.setStringList(key, items.map(encode).toList());
    } catch (e, s) {
      AppErrorService.log('storage.write($key)', e, s);
      throw StorageException('فشل حفظ البيانات ($key)', e);
    }
    if (!ok) {
      AppErrorService.log('storage.write($key)', 'setStringList رجع false');
      throw StorageException('فشل حفظ البيانات ($key)');
    }
  }

  // NOTES
  static List<Note> notes() => _read(notesKey, Note.fromJson);

  static Note? getNote(String id) {
    for (final n in notes()) {
      if (n.id == id) return n;
    }
    return null;
  }

  static Future<void> saveNote(Note note) => _serialize(() async {
        final list = notes()..removeWhere((n) => n.id == note.id);
        list.add(note);
        await _write(notesKey, list, (n) => jsonEncode(n.toJson()));
        AppState.instance.notify();
      });

  static Future<void> deleteNote(String id) => _serialize(() async {
        final list = notes()..removeWhere((n) => n.id == id);
        await _write(notesKey, list, (n) => jsonEncode(n.toJson()));
        AppState.instance.notify();
      });

  static Future<void> togglePin(String id) => _serialize(() async {
        final list = notes();
        final idx = list.indexWhere((n) => n.id == id);
        if (idx == -1) return;
        list[idx] = list[idx].copyWith(pinned: !list[idx].pinned);
        await _write(notesKey, list, (n) => jsonEncode(n.toJson()));
        AppState.instance.notify();
      });

  // CATEGORIES
  static List<Category> categories() => _read(categoriesKey, Category.fromJson);

  static Category? getCategory(String id) {
    for (final c in categories()) {
      if (c.id == id) return c;
    }
    return null;
  }

  static Future<void> saveCategory(Category category) => _serialize(() async {
        final list = categories()..removeWhere((c) => c.id == category.id);
        list.add(category);
        await _write(categoriesKey, list, (c) => jsonEncode(c.toJson()));
        AppState.instance.notify();
      });

  static Future<void> deleteCategory(String id) => _serialize(() async {
        final list = categories()..removeWhere((c) => c.id == id);
        await _write(categoriesKey, list, (c) => jsonEncode(c.toJson()));
        AppState.instance.notify();
      });

  static Map<String, int> getCategoriesWithCount() {
    final list = categories();
    final counts = <String, int>{for (final c in list) c.id: 0};
    for (final n in notes()) {
      final cid = n.categoryId;
      if (cid != null && counts.containsKey(cid)) {
        counts[cid] = counts[cid]! + 1;
      }
    }
    return counts;
  }

  static bool wasSeeded() => _prefs.getBool(seededKey) ?? false;

  static Future<void> markSeeded() async {
    await _prefs.setBool(seededKey, true);
  }

  static int storageBytes() {
    var total = 0;
    for (final key in _prefs.getKeys()) {
      final v = _prefs.get(key);
      if (v is String) {
        total += v.length;
      } else if (v is List) {
        total += v.toString().length;
      }
    }
    return total;
  }

  static Future<void> clearAll() => _serialize(() async {
        await _prefs.clear();
        AppState.instance.notify();
      });
}
