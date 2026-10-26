import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted settings: theme mode, font size, vault state.
class SettingsService {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  static late SharedPreferences _p;

  static const kThemeMode = 'theme_mode'; // 'system' | 'light' | 'dark'
  static const kFontSize = 'font_size'; // double
  static const kLanguage = 'language';  // 'ar' | 'en'

  static Future<void> init() async {
    _p = await SharedPreferences.getInstance();
  }

  static ThemeMode get themeMode {
    final v = _p.getString(kThemeMode) ?? 'system';
    switch (v) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    final v = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await _p.setString(kThemeMode, v);
  }

  static double get fontSize =>
      _p.getDouble(kFontSize) ?? 14.0;

  static Future<void> setFontSize(double size) =>
      _p.setDouble(kFontSize, size);

  static String get language =>
      _p.getString(kLanguage) ?? 'ar';

  static Future<void> setLanguage(String code) =>
      _p.setString(kLanguage, code);
}