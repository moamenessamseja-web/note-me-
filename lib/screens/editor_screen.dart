import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';
import 'package:note_me/design/strings.dart';
import '../services/app_error_service.dart';
import '../services/storage_service.dart';
import '../services/vault_service.dart';
import '../models/note.dart';

class EditorScreen extends StatefulWidget {
  final Note? note;
  const EditorScreen({super.key, this.note});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  late final TextEditingController _tagsCtrl;
  String? _selectedCategory;
  List<String> _tags = [];
  bool _vault = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.note?.content ?? '');
    _selectedCategory = widget.note?.categoryId;
    _tags = List.from(widget.note?.tags ?? []);
    _tagsCtrl = TextEditingController(text: _tags.join(', '));
    _vault = widget.note?.vault ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cats = StorageService.categories();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? L.new_note : L.edit_note),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
            tooltip: L.save,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpace.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  labelText: L.note_title,
                  hintText: L.note_title,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                style: AppText.body,
              ),
              SizedBox(height: AppSpace.x3),
              TextField(
                controller: _contentCtrl,
                decoration: InputDecoration(
                  labelText: L.note_content,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                style: AppText.body.copyWith(fontFamily: 'monospace'),
                maxLines: 12,
              ),
              SizedBox(height: AppSpace.x3),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: L.note_category,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text(L.filter_all)),
                  ...cats.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
                ],
                onChanged: (v) => setState(() => _selectedCategory = v),
              ),
              SizedBox(height: AppSpace.x3),
              TextField(
                controller: _tagsCtrl,
                decoration: InputDecoration(
                  labelText: L.note_tags,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                onChanged: (v) => _tags = v.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList(),
              ),
              SizedBox(height: AppSpace.x3),
              SwitchListTile(
                title: Text(L.note_vault, style: AppText.body),
                value: _vault,
                onChanged: (v) => setState(() => _vault = v),
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L.note_empty_title), backgroundColor: AppColors.danger),
      );
      return;
    }

    final now = DateTime.now();
    final note = Note(
      id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: _contentCtrl.text.trim(),
      categoryId: _selectedCategory,
      tags: _tags,
      vault: _vault,
      createdAt: widget.note?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      if (_vault) {
        // Encrypt and save to the vault; drop the plaintext copy if it was a regular note.
        await VaultService.saveVaultNote(note);
        final prev = widget.note;
        if (prev != null && !prev.vault) {
          await StorageService.deleteNote(prev.id);
        }
      } else {
        await StorageService.saveNote(note);
        final prev = widget.note;
        if (prev != null && prev.vault) {
          // The note left the vault: remove the encrypted duplicate.
          await VaultService.deleteVaultNote(prev.id);
        }
      }
    } catch (e, st) {
      AppErrorService.log('editor.save', e, st);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppErrorService.userMessage(e)),
            backgroundColor: AppColors.danger,
          ),
        );
      }
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L.saved), backgroundColor: AppColors.success),
      );
      Navigator.pop(context);
    }
  }
}
