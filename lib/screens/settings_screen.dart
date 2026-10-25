import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';
import 'package:note_me/design/app_theme.dart';
import 'package:note_me/design/strings.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L.nav_settings)),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppSpace.x2),
          children: [
            _buildThemeSection(context),
            _buildLanguageSection(context),
            _buildFontSizeSection(context),
            _buildBackupSection(context),
            _buildResetSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(L.appearance, style: AppText.body),
            trailing: DropdownButton<ThemeMode>(
              value: SettingsService.themeMode,
              items: ThemeMode.values.map((mode) => DropdownMenuItem(
                value: mode,
                child: Text(mode.toString()),
              )).toList(),
              onChanged: (v) => SettingsService.setThemeMode(v ?? ThemeMode.system),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(L.language, style: AppText.body),
            trailing: DropdownButton<String>(
              value: SettingsService.language,
              items: ['ar', 'en'].map((code) => DropdownMenuItem(
                value: code,
                child: Text(code == 'ar' ? L.lang_arabic : L.lang_english),
              )).toList(),
              onChanged: (v) => SettingsService.setLanguage(v ?? 'en'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(L.font_size, style: AppText.body),
            trailing: DropdownButton<double>(
              value: SettingsService.fontSize,
              items: [10.0, 12.0, 14.0, 16.0, 18.0, 20.0].map((size) => DropdownMenuItem(
                value: size,
                child: Text(size.toString()),
              )).toList(),
              onChanged: (v) => SettingsService.setFontSize(v ?? 14.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.backup, color: AppColors.primary),
            title: Text(L.backup_restore, style: AppText.body),
            subtitle: Text('إنشاء أو استعادة نسخ البيانات', style: AppText.bodySm),
            onTap: () {
              // Navigate to backup screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResetSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.delete_forever, color: AppColors.danger),
            title: Text(L.reset_data, style: AppText.body.copyWith(color: AppColors.danger)),
            subtitle: Text(L.reset_data_confirm, style: AppText.bodySm),
            onTap: () {
              // Show confirmation dialog and reset data
            },
          ),
        ],
      ),
    );
  }
}
