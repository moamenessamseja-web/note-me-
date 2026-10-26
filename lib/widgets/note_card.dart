import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';
import 'package:note_me/design/app_theme.dart';
import 'package:note_me/design/strings.dart';
import 'package:note_me/screens/reader_screen.dart';
import 'package:note_me/services/app_state.dart';
import 'package:note_me/services/storage_service.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onDeleted;
  final VoidCallback? onVaultTap;

  const NoteCard({super.key, required this.note, this.onDeleted, this.onVaultTap});

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
              onSelected: (v) async {
                if (v == 'pin') {
                  await StorageService.togglePin(note.id);
                  if (context.mounted) AppState.instance.notify();
                } else if (v == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('حذف الملاحظة'),
                      content: Text('هل أنت متأكد من حذف هذه الملاحظة؟ لا يمكن التراجع عن هذا الإجراء.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(L.delete, style: TextStyle(color: AppColors.danger)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await StorageService.deleteNote(note.id);
                    onDeleted?.call();
                    if (context.mounted) AppState.instance.notify();
                  }
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'pin', child: Text(note.pinned ? 'إلغاء التثبيت' : 'تثبيت')),
                PopupMenuItem(value: 'delete', child: Text('حذف')),
              ],
              icon: Icon(Icons.more_vert, size: AppIconSize.sm, color: AppColors.textDisabled),
            ),
          ],
        ),
        onTap: () {
          if (note.vault) {
            // Vault notes must be opened via VaultScreen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('الملاحظات المشفرة تُفتح من شاشة الخزنة'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReaderScreen(
                title: note.title,
                content: note.content,
              ),
            ),
          );
        },
      ),
    );
  }
}
