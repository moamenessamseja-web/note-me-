import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';
import 'package:note_me/design/app_theme.dart';
import 'package:note_me/design/strings.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final color = Colors.white.withValues(alpha: 0.9);
    return Card(
      color: color,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: AppColors.border, width: 0.5),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpace.x4, vertical: AppSpace.x3),
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryTint,
          child: Icon(Icons.note, size: AppIconSize.md, color: AppColors.primary),
        ),
        title: Text(
          note.title,
          style: AppText.body.copyWith(fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          note.preview,
          style: AppText.bodySm,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            if (note.pinned)
              Icon(Icons.push_pin, size: AppIconSize.sm, color: AppColors.primary),
            if (note.vault)
              Icon(Icons.lock, size: AppIconSize.sm, color: AppColors.accent),
            PopupMenuButton<String>(
              onSelected: (v) {},
              itemBuilder: (context) => [
                PopupMenuItem(value: 'pin', child: Text(note.pinned ? 'إلغاء التثبيت' : 'تثبيت')),
                PopupMenuItem(value: 'delete', child: Text('حذف')),
              ],
              icon: Icon(Icons.more_vert, size: AppIconSize.sm, color: AppColors.textDisabled),
            ),
          ],
        ),
        onTap: () {
          // Open reader
        },
      ),
    );
  }
}
