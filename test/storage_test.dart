import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:note_me/models/category.dart';
import 'package:note_me/models/note.dart';
import 'package:note_me/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Note _note(String id, {String title = 't', String? categoryId}) => Note(
      id: id,
      title: title,
      content: 'body $id',
      categoryId: categoryId,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await StorageService.init();
  });

  setUp(() async {
    await StorageService.clearAll();
  });

  test('saveNote stores a note that notes() returns', () async {
    await StorageService.saveNote(_note('a', title: 'Hello'));
    final all = StorageService.notes();
    expect(all.length, 1);
    expect(all.first.title, 'Hello');
    expect(StorageService.getNote('a')?.content, 'body a');
  });

  test('saveNote with the same id updates instead of duplicating', () async {
    await StorageService.saveNote(_note('a', title: 'v1'));
    await StorageService.saveNote(_note('a', title: 'v2'));
    final all = StorageService.notes();
    expect(all.length, 1);
    expect(all.first.title, 'v2');
  });

  test('deleteNote removes only the targeted note', () async {
    await StorageService.saveNote(_note('a'));
    await StorageService.saveNote(_note('b'));
    await StorageService.deleteNote('a');
    final ids = StorageService.notes().map((n) => n.id).toList();
    expect(ids, ['b']);
    expect(StorageService.getNote('a'), isNull);
  });

  test('togglePin flips the flag and flips back', () async {
    await StorageService.saveNote(_note('a'));
    await StorageService.togglePin('a');
    expect(StorageService.getNote('a')?.pinned, isTrue);
    await StorageService.togglePin('a');
    expect(StorageService.getNote('a')?.pinned, isFalse);
  });

  test('data is really written to the preferences store as JSON', () async {
    await StorageService.saveNote(_note('a', title: 'persisted'));
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(StorageService.notesKey);
    expect(raw, isNotNull);
    expect(raw!.length, 1);
    final decoded = jsonDecode(raw.first) as Map<String, dynamic>;
    expect(decoded['title'], 'persisted');
    expect(Note.fromJson(decoded).id, 'a');
  });

  test('corrupt records are skipped, valid ones survive', () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(StorageService.notesKey, <String>[
      'not json at all',
      '[1,2,3]',
      jsonEncode(_note('ok', title: 'fine').toJson()),
    ]);
    final all = StorageService.notes();
    expect(all.length, 1);
    expect(all.first.id, 'ok');
  });

  test('categories: save, count notes per category, delete', () async {
    await StorageService.saveCategory(
        const Category(id: 'w', name: 'Work', color: 'blue-600', icon: 'tag'));
    await StorageService.saveCategory(
        const Category(id: 'p', name: 'Personal', color: 'red-500', icon: 'tag'));
    await StorageService.saveNote(_note('1', categoryId: 'w'));
    await StorageService.saveNote(_note('2', categoryId: 'w'));
    await StorageService.saveNote(_note('3', categoryId: 'p'));
    await StorageService.saveNote(_note('4'));
    final counts = StorageService.getCategoriesWithCount();
    expect(counts['w'], 2);
    expect(counts['p'], 1);
    await StorageService.deleteCategory('p');
    expect(StorageService.categories().map((c) => c.id).toList(), ['w']);
  });

  test('concurrent saves are all kept (write gate serialises them)', () async {
    await Future.wait(<Future<void>>[
      for (var i = 0; i < 10; i++) StorageService.saveNote(_note('n$i')),
    ]);
    expect(StorageService.notes().length, 10);
  });

  test('clearAll empties notes', () async {
    await StorageService.saveNote(_note('a'));
    await StorageService.clearAll();
    expect(StorageService.notes(), isEmpty);
  });
}
