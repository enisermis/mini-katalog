import 'package:flutter/material.dart';

// Uygulamanin renklerini tek yerde topladim, bir rengi degistirmek istersem sadece burayi duzenliyorum
class AppColors {
  static const primary = Color(0xFF0F766E); // koyu turkuaz
  static const primaryDark = Color(0xFF134E4A);
  static const accent = Color(0xFFF59E0B); // turuncu vurgu
  static const background = Color(0xFFF6F4EF); // sicak kirik beyaz
  static const card = Colors.white;
  static const textMuted = Color(0xFF6B7280);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.background,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primaryDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
