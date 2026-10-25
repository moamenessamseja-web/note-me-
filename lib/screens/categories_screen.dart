import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';
import 'package:note_me/design/app_theme.dart';
import 'package:note_me/design/strings.dart';
import '../services/storage_service.dart';
import '../models/category.dart';
import '../widgets/note_card.dart';
import '../models/note.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final cats = StorageService.categories();
    final all = StorageService.notes();

    return Scaffold(
      appBar: AppBar(title: Text(L.nav_categories)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpace.x4, vertical: AppSpace.x3),
              child: TextField(
                decoration: InputDecoration(
                  hintText: L.category_name,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => setState(() {}),
                child: ListView.builder(
                  padding: EdgeInsets.all(AppSpace.x2),
                  itemCount: cats.where((c) => c.name.toLowerCase().contains(_query.toLowerCase())).length,
                  itemBuilder: (context, i) {
                    final cat = cats.where((c) => c.name.toLowerCase().contains(_query.toLowerCase())).toList()[i];
                    final notes = all.where((n) => n.categoryId == cat.id && !(n.vault && n.content.isEmpty)).toList();
                    return Card(
                      margin: EdgeInsets.only(bottom: AppSpace.x2),
                      child: ExpansionTile(
                        title: Text(cat.name, style: AppText.body.copyWith(fontWeight: FontWeight.w700)),
                        leading: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primaryTint,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Icon(Icons.category, size: AppIconSize.md, color: AppColors.primary),
                        ),
                        subtitle: Text('${notes.length} ${L.nav_notes}', style: AppText.bodySm),
                        children: [
                          for (final note in notes)
                            ListTile(
                              title: Text(note.title, style: AppText.body),
                              subtitle: Text(note.preview, style: AppText.bodySm),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: AppColors.danger),
                                onPressed: () async {
                                  await StorageService.deleteNote(note.id);
                                  setState(() {});
                                },
                              ),
                            ),
                        ],
                      ),
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
}
