import 'package:flutter/material.dart';

class AppTheme {
  static const double paddingTiny = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMediumSmall = 12.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingHuge = 32.0;

  static const Color primaryGreen = Color(0xFF1d8a3c);
  static const Color backgroundMint = Color(0xFFF0FAF2);
  static const Color textDark = Color(0xFF1a2e1a);
  static const Color borderLight = Color(0xFFD4E8D8);

  static ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: primaryGreen,
    primary: primaryGreen,
  );

  static ThemeData theme = ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: backgroundMint,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1a1a2e),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );
}
