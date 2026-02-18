/*
 * ----------------------------------------------------------------------------
 * KATMAN: KONFİGÜRASYON (Configuration)
 * ----------------------------------------------------------------------------
 */
import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFFFF8FA3);
  static const secondaryColor = Color(0xFFC77DFF);
  static const accentColor = Color(0xFFFFC6FF);
  static const backgroundColor = Color(0xFFFDF0F3);
  static const glassWhite = Color(0x99FFFFFF);

  static final gradientBg = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFFFCE4EC),
      const Color(0xFFF8BBD0).withOpacity(0.4),
      const Color(0xFFE1BEE7).withOpacity(0.4),
    ],
  );
}
