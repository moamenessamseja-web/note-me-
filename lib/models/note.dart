/// Core domain models for note-me.
///
/// A [Note] is the atomic unit of the notebook. Vault notes keep their
/// title and body encrypted at rest — the plaintext never touches disk.
library;

class Note {
  final String id;
  final String title;
  final String content;
  final String? categoryId;
  final List<String> tags;
  final bool pinned;
  final bool vault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.categoryId,
    this.tags = const [],
    this.pinned = false,
    this.vault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? categoryId,
    bool clearCategory = false,
    List<String>? tags,
    bool? pinned,
    bool? vault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      tags: tags ?? this.tags,
      pinned: pinned ?? this.pinned,
      vault: vault ?? this.vault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'categoryId': categoryId,
        'tags': tags,
        'pinned': pinned,
        'vault': vault,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> j) => Note(
        id: (j['id'] as String?) ?? '',
        title: (j['title'] as String?) ?? '',
        content: (j['content'] as String?) ?? '',
        categoryId: j['categoryId'] as String?,
        tags: (j['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        pinned: (j['pinned'] as bool?) ?? false,
        vault: (j['vault'] as bool?) ?? false,
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(j['updatedAt'] as String? ?? '') ?? DateTime.now(),
      );

  /// Plain-text preview used in list rows (strips markdown syntax).
  String get preview {
    final raw = content.replaceAll(RegExp(r'[#*_>`~\[\]()]'), ' ').trim();
    final oneLine = raw.replaceAll(RegExp(r'\s+'), ' ');
    return oneLine.length > 140 ? '${oneLine.substring(0, 140)}…' : oneLine;
  }
}
