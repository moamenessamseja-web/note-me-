import 'package:flutter_test/flutter_test.dart';
import 'package:note_me/models/category.dart';
import 'package:note_me/models/note.dart';

Note _note({String id = 'n1', String title = 'عنوان', String content = 'نص'}) => Note(
      id: id,
      title: title,
      content: content,
      createdAt: DateTime(2026, 1, 1, 10),
      updatedAt: DateTime(2026, 1, 2, 11),
    );

void main() {
  group('Note JSON', () {
    test('round-trips every field', () {
      final n = _note().copyWith(
        categoryId: 'work',
        tags: const ['a', 'ب'],
        pinned: true,
        vault: true,
      );
      final back = Note.fromJson(n.toJson());
      expect(back.id, 'n1');
      expect(back.title, 'عنوان');
      expect(back.content, 'نص');
      expect(back.categoryId, 'work');
      expect(back.tags, ['a', 'ب']);
      expect(back.pinned, isTrue);
      expect(back.vault, isTrue);
      expect(back.createdAt, DateTime(2026, 1, 1, 10));
      expect(back.updatedAt, DateTime(2026, 1, 2, 11));
    });

    test('fromJson tolerates missing and wrongly typed fields', () {
      final n = Note.fromJson(<String, dynamic>{'id': 'x'});
      expect(n.id, 'x');
      expect(n.title, '');
      expect(n.content, '');
      expect(n.tags, isEmpty);
      expect(n.pinned, isFalse);
      expect(n.vault, isFalse);
      expect(n.categoryId, isNull);
    });
  });

  group('Note.copyWith', () {
    test('changes only what is asked', () {
      final n = _note().copyWith(title: 'جديد');
      expect(n.title, 'جديد');
      expect(n.content, 'نص');
      expect(n.id, 'n1');
    });

    test('clearCategory removes the category', () {
      final n = _note().copyWith(categoryId: 'c1');
      expect(n.categoryId, 'c1');
      expect(n.copyWith(clearCategory: true).categoryId, isNull);
    });
  });

  group('Note.preview', () {
    test('strips markdown punctuation and collapses whitespace', () {
      final n = _note(content: '# Title\n\n**bold**   and `code`');
      expect(n.preview, 'Title bold and code');
    });

    test('truncates long content with an ellipsis', () {
      final n = _note(content: 'a' * 300);
      expect(n.preview.length, 141);
      expect(n.preview.endsWith('…'), isTrue);
    });
  });

  group('Category JSON', () {
    test('round-trips and applies defaults', () {
      const c = Category(id: 'c1', name: 'عمل', color: 'red-500', icon: 'work');
      final back = Category.fromJson(c.toJson());
      expect(back.name, 'عمل');
      expect(back.color, 'red-500');
      expect(back.icon, 'work');
      final d = Category.fromJson(<String, dynamic>{'id': 'c2'});
      expect(d.color, 'blue-600');
      expect(d.icon, 'tag');
    });
  });
}
