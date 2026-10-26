import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';
import 'package:note_me/design/app_theme.dart';
import 'package:note_me/design/strings.dart';
import '../services/storage_service.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String _query = '';
  String? _selectedCategory;
  int _sortMode = 0;

  @override
  Widget build(BuildContext context) {
    final notes = _filteredNotes();
    final pinned = notes.where((n) => n.pinned).toList();
    final others = notes.where((n) => !n.pinned).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(L.nav_notes),
        actions: [
          PopupMenuButton<int>(
            onSelected: (v) => setState(() => _sortMode = v),
            itemBuilder: (context) => [
              PopupMenuItem(value: 0, child: Text(L.sort_latest)),
              PopupMenuItem(value: 1, child: Text(L.sort_oldest)),
              PopupMenuItem(value: 2, child: Text(L.sort_title_asc)),
              PopupMenuItem(value: 3, child: Text(L.sort_title_desc)),
            ],
            icon: const Icon(Icons.sort),
            tooltip: L.sort,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildCategoryChips(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => setState(() {}),
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpace.x2),
                  itemCount: pinned.length + others.length + (pinned.isEmpty && _query.isEmpty && _selectedCategory == null ? 1 : 0),
                  itemBuilder: (context, i) {
                    final all = [...pinned, ...others];
                    if (pinned.isEmpty && _query.isEmpty && _selectedCategory == null) {
                      if (i == 0) return _buildEmptyState();
                      i--;
                    }
                    if (i < 0 || i >= all.length) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.x2),
                      child: NoteCard(note: all[i]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpace.x4, vertical: AppSpace.x3),
      child: TextField(
        decoration: InputDecoration(
          hintText: L.search_hint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: BorderSide(color: AppColors.border, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        onChanged: (v) => setState(() => _query = v),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final cats = StorageService.categories();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: AppSpace.x4),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: AppSpace.x2),
            child: ChoiceChip(
              label: Text(L.filter_all, style: TextStyle(fontFamily: 'Tajawal')),
              selected: _selectedCategory == null,
              onSelected: (v) => setState(() => _selectedCategory = v ? null : null),
              selectedColor: AppColors.primaryTint,
              backgroundColor: AppColors.surface,
            ),
          ),
          for (var i = 0; i < cats.length; i++)
            Padding(
              padding: EdgeInsets.only(right: AppSpace.x2),
              child: ChoiceChip(
                label: Text(cats[i].name, style: TextStyle(fontFamily: 'Tajawal')),
                selected: _selectedCategory == cats[i].id,
                onSelected: (v) => setState(() => _selectedCategory = v ? cats[i].id : null),
                selectedColor: AppColors.primaryTint,
                backgroundColor: AppColors.surface,
                labelPadding: EdgeInsets.symmetric(horizontal: AppSpace.x3),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_add, size: 64, color: AppColors.textDisabled),
          const SizedBox(height: 16),
          Text(L.no_notes, style: AppText.h2),
          const SizedBox(height: 8),
          Text(L.no_notes_sub, style: AppText.bodySm, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  List<Note> _filteredNotes() {
    final all = StorageService.notes();
    return all
        .where((n) => !n.vault || n.content.isNotEmpty)
        .where((n) {
          if (_selectedCategory != null) {
            return n.categoryId == _selectedCategory;
          }
          return true;
        })
        .where((n) {
          if (_query.isEmpty) return true;
          final q = _query.toLowerCase();
          return n.title.toLowerCase().contains(q) ||
              n.content.toLowerCase().contains(q) ||
              n.tags.any((t) => t.toLowerCase().contains(q));
        })
        .toList()
      ..sort((a, b) => _sortNotes(a, b));
  }

  int _sortNotes(Note a, Note b) {
    switch (_sortMode) {
      case 1:
        return a.createdAt.compareTo(b.createdAt);
      case 2:
        return a.title.compareTo(b.title);
      case 3:
        return b.title.compareTo(a.title);
      default:
        return b.createdAt.compareTo(a.createdAt);
    }
  }
}
