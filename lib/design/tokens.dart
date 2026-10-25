import 'package:flutter/material.dart';

/// Design system — note-me (Mindbook Pro clone).
///
/// Deep-sea blue (structure) + teal (interaction) + gold (attention only)
/// on soft sea-mist background.
class AppColors {
  AppColors._();

  static const background = Color(0xFFF5F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFEDF1F6);
  static const surfaceMid = Color(0xFFE9EEF3);
  static const surfaceDark = Color(0xFF072F47);

  static const border = Color(0xFFE2E8F0);
  static const borderStrong = Color(0xFFCBD5E1);

  static const textPrimary = Color(0xFF1E293B);
  static const textSecondary = Color(0xFF55657A);
  static const textDisabled = Color(0xFF98A4B3);

  static const primary = Color(0xFF084A6F);
  static const primaryStrong = Color(0xFF063A55);
  static const primaryTint = Color(0xFFE4EEF4);
  static const primaryLight = Color(0xFFD3E5EF);

  static const secondary = Color(0xFF00A3A3);
  static const secondaryStrong = Color(0xFF0A6E75);
  static const secondaryTint = Color(0xFFDFF3F3);

  static const accent = Color(0xFFF4B400);
  static const accentStrong = Color(0xFF8A6400);
  static const accentTint = Color(0xFFFDF1D4);

  static const success = Color(0xFF157347);
  static const successTint = Color(0xFFE6F4EC);
  static const warning = Color(0xFF9A5B00);
  static const warningTint = Color(0xFFFBEEDA);
  static const danger = Color(0xFFB3261E);
  static const dangerTint = Color(0xFFFBE9E7);
  static const info = Color(0xFF0A6E75);
  static const infoTint = Color(0xFFDFF3F3);

  static const chart1 = Color(0xFF084A6F);
  static const chart2 = Color(0xFF00A3A3);
  static const chart3 = Color(0xFFF4B400);
  static const chart4 = Color(0xFFD07A4E);
  static const chart5 = Color(0xFF6B7A8F);
  static const chartGrid = Color(0xFFE6EBF1);

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF5F7FA)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF084A6F), Color(0xFF063A55)],
  );
}

class AppSpace {
  AppSpace._();
  static const double x1 = 4.0;
  static const double x2 = 8.0;
  static const double x3 = 12.0;
  static const double x4 = 16.0;
  static const double x5 = 20.0;
  static const double x6 = 24.0;
  static const double x8 = 32.0;
  static const double x10 = 40.0;
  static const double x12 = 48.0;
  static const double x16 = 64.0;
}

class AppRadius {
  AppRadius._();
  static const double xs = 6.0;
  static const double sm = 10.0;
  static const double md = 14.0;
  static const double lg = 18.0;
  static const double xl = 24.0;
  static const double xxl = 24.0;
  static const double full = 9999.0;
}

class AppTouch {
  AppTouch._();
  static const double min = 44.0;
  static const double iconBtn = 44.0;
  static const double navItem = 64.0;
  static const double actionRow = 72.0;
}

class AppIconSize {
  AppIconSize._();
  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xl2 = 40.0;
}

class AppShadow {
  AppShadow._();
  static const List<BoxShadow> flat = [];
  static const List<BoxShadow> raised = [
    BoxShadow(color: Color(0x0D082A40), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(
      color: Color(0x24082A40),
      blurRadius: 20,
      spreadRadius: -12,
      offset: Offset(0, 8),
    ),
  ];
  static const List<BoxShadow> floating = [
    BoxShadow(color: Color(0x0F082A40), blurRadius: 4, offset: Offset(0, 2)),
    BoxShadow(
      color: Color(0x33082A40),
      blurRadius: 32,
      spreadRadius: -16,
      offset: Offset(0, 16),
    ),
  ];
}

class AppText {
  AppText._();
  static const h1 = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const h2 = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 14,
    color: AppColors.textPrimary,
  );
  static const bodySm = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 13,
    color: AppColors.textSecondary,
  );
  static const caption = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11,
    color: AppColors.textDisabled,
  );
}
