import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF2F6A4F);
  static const Color primarySoft = Color(0xFFD7EEDD);
  static const Color secondary = Color(0xFF9BCB8A);
  static const Color accent = Color(0xFFB8D99B);
  static const Color background = Color(0xFFF5F8F2);
  static const Color card = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF1D2A1F);
  static const Color muted = Color(0xFF728370);
  static const Color success = Color(0xFF3B9B6A);
  static const Color warning = Color(0xFFE7A84D);
  static const Color danger = Color(0xFFE46D5F);

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
