import 'package:flutter/material.dart';
import 'package:greenlife_app/utils/app_colors.dart';

class AppTheme {
  static const Color primary = AppColors.primary;
  static const Color primarySoft = AppColors.primarySoft;
  static const Color secondary = AppColors.secondary;
  static const Color accent = AppColors.accent;
  static const Color background = AppColors.background;
  static const Color card = AppColors.card;
  static const Color text = AppColors.text;
  static const Color muted = AppColors.muted;
  static const Color success = AppColors.success;
  static const Color warning = AppColors.warning;
  static const Color danger = AppColors.danger;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: secondary,
      surface: card,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: text),
      titleTextStyle: TextStyle(
        color: text,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: text, fontWeight: FontWeight.w800),
      headlineMedium: TextStyle(color: text, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(color: text, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(color: text),
      bodyMedium: TextStyle(color: text),
    ),
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}