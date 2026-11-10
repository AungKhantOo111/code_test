import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF45C6DF); // Cyan button color
  static const Color primaryDark = Color(0xFF26B2CC);
  static const Color primaryLight = Color(0xFFE2F7FB);

  // Accent Colors
  static const Color accentPink = Color(0xFFFF5288); // Brand pink/magenta
  static const Color accentOrange = Color(0xFFFF8B3E);
  static const Color accentYellow = Color(0xFFFFC533);
  static const Color accentPurple = Color(0xFF9370DB);

  // Neutral Colors
  static const Color background = Color(0xFFFAF9F7);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF3F3F5);

  static const Color textPrimary = Color(0xFF1E2124);
  static const Color textSecondary = Color(0xFF757E8A);
  static const Color textMuted = Color(0xFFA0A6B2);

  static const Color border = Color(0xFFE5E7EB);
  static const Color borderFocused = Color(0xFF45C6DF);

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 16.0;
  static const double borderRadiusLg = 24.0;
  static const double borderRadiusPill = 999.0;
}

class AppTypography {
  AppTypography._();

  static const TextStyle titleLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );
}
