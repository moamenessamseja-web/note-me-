import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';
import 'package:note_me/design/strings.dart';
import '../services/app_state.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';
import 'notes_screen.dart';
import 'editor_screen.dart';
import 'reader_screen.dart';
import 'search_screen.dart';
import 'categories_screen.dart';
import 'themes_screen.dart';
import 'vault_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    AppState.instance.addListener(_onAppStateChanged);
    _maybeSeed();
  }

  @override
  void dispose() {
    AppState.instance.removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() => setState(() {});

  Future<void> _maybeSeed() async {
    if (StorageService.wasSeeded()) return;
    // Seed data placeholder — in production, this would load from seed.dart
    await StorageService.markSeeded();
  }

  static const _titles = [
    'الرئيسية',
    'الملاحظات',
    'محرر',
    'قارئ',
    'بحث',
    'التصنيفات',
    'الثيمات',
    'الخزنة',
    'الإعدادات',
    'حول التطبيق',
  ];

  List<(String, IconData, IconData)> get _dests => [
        (L.nav_home, Icons.home_outlined, Icons.home),
        (L.nav_notes, Icons.note_outlined, Icons.note),
        (L.nav_editor, Icons.edit_outlined, Icons.edit),
        (L.nav_reader, Icons.menu_book_outlined, Icons.menu_book),
        (L.nav_search, Icons.search_outlined, Icons.search),
        (L.nav_categories, Icons.category_outlined, Icons.category),
        (L.nav_themes, Icons.palette_outlined, Icons.palette),
        (L.nav_vault, Icons.lock_outline, Icons.lock),
        (L.nav_settings, Icons.settings_outlined, Icons.settings),
        (L.nav_about, Icons.info_outline, Icons.info),
      ];

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const NotesScreen(),
      const EditorScreen(),
      const ReaderScreen(),
      const SearchScreen(),
      const CategoriesScreen(),
      const ThemesScreen(),
      const VaultScreen(),
      const SettingsScreen(),
      const AboutScreen(),
    ];

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _index == 0 || _index == 1
          ? FloatingActionButton(
              onPressed: () => setState(() => _index = 2),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_titles[_index]),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < _dests.length; i++)
                Expanded(
                  child: _NavItem(
                    label: _dests[i].$1,
                    icon: _dests[i].$2,
                    selectedIcon: _dests[i].$3,
                    isSelected: _index == i,
                    onTap: () => setState(() => _index = i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpace.x4),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.horizontal(right: Radius.circular(AppRadius.xl)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(Icons.note_alt, size: AppIconSize.lg, color: Colors.white),
                  ),
                  SizedBox(height: AppSpace.x3),
                  Text(L.app_title, style: AppText.h1.copyWith(color: Colors.white, fontSize: 20)),
                  SizedBox(height: AppSpace.x1),
                  Text(L.app_tagline, style: AppText.body.copyWith(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                ],
              ),
            ),
            SizedBox(height: AppSpace.x2),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(icon: Icons.settings, label: L.nav_settings, onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                  }),
                  _DrawerItem(icon: Icons.info, label: L.nav_about, onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
                  }),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(AppSpace.x4),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.border, width: 0.5))),
              child: Text('note-me v1.0.0', style: AppText.caption, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isSelected ? selectedIcon : icon, size: AppIconSize.lg, color: isSelected ? AppColors.primary : AppColors.textDisabled),
              SizedBox(height: 2),
              Text(label, style: TextStyle(fontFamily: 'Tajawal', fontSize: 10, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400, color: isSelected ? AppColors.primary : AppColors.textDisabled), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: AppIconSize.md, color: AppColors.textSecondary),
      title: Text(label, style: AppText.body),
      trailing: Icon(Icons.arrow_forward, size: 16, color: AppColors.textDisabled),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: AppSpace.x4, vertical: AppSpace.x1),
    );
  }
}
