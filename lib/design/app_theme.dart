import 'package:flutter/material.dart';

import 'package:note_me/design/tokens.dart';

/// Light/dark theme definitions for note-me.
class AppTheme {
  AppTheme._();

  static ThemeData light() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          error: AppColors.danger,
          onError: Colors.white,
        ),
        fontFamily: 'Tajawal',
        textTheme: TextTheme(
          headlineLarge: AppText.h1,
          headlineMedium: AppText.h2,
          bodyLarge: AppText.body,
          bodyMedium: AppText.bodySm,
          bodySmall: AppText.caption,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      );

  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.surfaceDark,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.secondary,
          surface: AppColors.surfaceDark,
          onSurface: Colors.white70,
          error: AppColors.danger,
          onError: Colors.white,
        ),
        fontFamily: 'Tajawal',
        textTheme: TextTheme(
          headlineLarge: AppText.h1.copyWith(color: Colors.white),
          headlineMedium: AppText.h2.copyWith(color: Colors.white),
          bodyLarge: AppText.body.copyWith(color: Colors.white70),
          bodyMedium: AppText.bodySm.copyWith(color: Colors.white60),
          bodySmall: AppText.caption.copyWith(color: Colors.white54),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfaceDark,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.surfaceDark,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.white70,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
      );
}
