import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

class AppTheme {
 // Common spacing
  static const double paddingTiny = 4.0;
  static double paddingSmall = 8.0;
  static const double paddingMediumSmall = 12.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingHuge = 32.0;

  static const double cardElevation = 4.0;
  static const double cardBorderRadius = 12.0;

// Text styles
  static const TextStyle largeHeading = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle mediumHeading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle smallHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

 // App color
  static ColorScheme colorScheme = ColorScheme.fromSeed(
           seedColor: Colors.green,     
   );
  //static TextTheme textTheme = GoogleFonts.nunitoTextTheme();
}