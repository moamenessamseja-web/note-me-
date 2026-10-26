import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';
import 'package:note_me/design/strings.dart';
import '../services/storage_service.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  String? _selectedCategory;
  int _sortMode = 0; // 0=later, 1=older, 2=title-asc, 3=title-desc

  @override
  Widget build(BuildContext context) {
    final notes = _filteredNotes();
    final pinned = notes.where((n) => n.pinned).toList();
    final others = notes.where((n) => !n.pinned).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => setState(() {}),
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpace.x2),
                  itemCount: pinned.length + others.length + 1,
                  itemBuilder: (context, i) {
                    final offset = i - 1;
                    if (i == 0) return _buildCategoryChips();
                    if (offset == -1 && pinned.isEmpty && _query.isEmpty && _selectedCategory == null) {
                      return _buildEmptyState();
                    }
                    final all = [...pinned, ...others];
                    if (offset < 0 || offset >= all.length) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.x2),
                      child: NoteCard(note: all[offset]),
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
          hintText: L.search,
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
    final all = [
      {'id': 'all', 'name': L.filter_all, 'color': AppColors.primary},
      ...StorageService.categories().map((c) => {'id': c.id, 'name': c.name, 'color': AppColors.primary}),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: AppSpace.x4),
      child: Row(
        children: [
          for (var i = 0; i < all.length; i++)
            Padding(
              padding: EdgeInsets.only(right: AppSpace.x2),
              child: ChoiceChip(
                label: Text(all[i]['name'] as String, style: TextStyle(fontFamily: 'Tajawal')),
                selected: _selectedCategory == all[i]['id'],
                onSelected: (v) => setState(() => _selectedCategory = v ? all[i]['id'] as String : null),
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
          if (_selectedCategory != null && _selectedCategory != 'all') {
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
