import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _bg = Color(0xFFFFF8E7);
  static const Color _ink = Color(0xFF111111);
  static const Color _accentYellow = Color(0xFFFFD93D);
  static const Color _accentBlue = Color(0xFF6BCBFF);
  static const Color _accentPink = Color(0xFFFF6B9E);

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _accentYellow,
        primary: _accentYellow,
        secondary: _accentBlue,
        surface: Colors.white,
        onPrimary: _ink,
        onSecondary: _ink,
        onSurface: _ink,
        brightness: Brightness.light,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: _ink, displayColor: _ink),
      appBarTheme: const AppBarTheme(
        backgroundColor: _accentYellow,
        foregroundColor: _ink,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: _ink, width: 2),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _ink, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _ink, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _accentPink, width: 3),
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentBlue,
          foregroundColor: _ink,
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: _ink, width: 2),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: const BorderSide(color: _ink, width: 2),
        ),
        labelStyle: const TextStyle(color: _ink, fontWeight: FontWeight.w700),
      ),
    );
  }
}
