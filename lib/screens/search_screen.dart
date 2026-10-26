import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';
import 'package:note_me/design/strings.dart';
import '../services/storage_service.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final notes = _filteredNotes();

    return Scaffold(
      appBar: AppBar(title: Text(L.nav_search)),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildCategoryChips(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => setState(() {}),
                child: ListView.builder(
                  padding: EdgeInsets.all(AppSpace.x2),
                  itemCount: notes.length,
                  itemBuilder: (context, i) => Padding(
                    padding: EdgeInsets.only(bottom: AppSpace.x2),
                    child: NoteCard(note: notes[i]),
                  ),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
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
          for (var c in cats)
            Padding(
              padding: EdgeInsets.only(right: AppSpace.x2),
              child: ChoiceChip(
                label: Text(c.name, style: TextStyle(fontFamily: 'Tajawal')),
                selected: _selectedCategory == c.id,
                onSelected: (v) => setState(() => _selectedCategory = v ? c.id : null),
                selectedColor: AppColors.primaryTint,
                backgroundColor: AppColors.surface,
                labelPadding: EdgeInsets.symmetric(horizontal: AppSpace.x3),
              ),
            ),
        ],
      ),
    );
  }

  List<Note> _filteredNotes() {
    final all = StorageService.notes();
    return all
        .where((n) => !n.vault || n.content.isNotEmpty)
        .where((n) =>
            (_selectedCategory == null || n.categoryId == _selectedCategory) &&
            (_query.isEmpty ||
                n.title.toLowerCase().contains(_query.toLowerCase()) ||
                n.content.toLowerCase().contains(_query.toLowerCase()) ||
                n.tags.any((t) => t.toLowerCase().contains(_query.toLowerCase()))))
        .toList();
  }
}
