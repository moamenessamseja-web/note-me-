import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';
import 'package:note_me/design/strings.dart';
import '../services/settings_service.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L.nav_themes)),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppSpace.x2),
          children: [
            _buildThemeSection(L.theme_light, ThemeMode.light),
            _buildThemeSection(L.theme_dark, ThemeMode.dark),
            _buildThemeSection(L.theme_system, ThemeMode.system),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(String title, ThemeMode mode) {
    return ListTile(
      title: Text(title, style: AppText.body),
      trailing: Radio<ThemeMode>(
        value: mode,
        groupValue: SettingsService.themeMode,
        onChanged: (v) => SettingsService.setThemeMode(v ?? ThemeMode.system),
      ),
      onTap: () => SettingsService.setThemeMode(mode),
    );
  }
}
