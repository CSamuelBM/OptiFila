import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryDark    = Color(0xFF004D6B);
  static const Color headerColor    = Color(0xFF1B5E80);
  static const Color accentBlue     = Color(0xFF2E9BC5);
  static const Color accentBlueDark = Color(0xFF2362A1);
  static const Color bgLight        = Color(0xFFE8F5FD);
  static const Color bgGray         = Color(0xFFF0F7FC);
  static const Color cardWhite      = Color(0xFFFFFFFF);
  static const Color textPrimary    = Color(0xFF1A3550);
  static const Color textSecondary  = Color(0xFF5A7A8A);
  static const Color textLight      = Color(0xFF9CB8C8);
  static const Color borderColor    = Color(0xFFD2E3F5);
  static const Color successGreen   = Color(0xFF22C55E);
  static const Color errorRed       = Color(0xFFEF4444);
  // Aliases para compatibilidad con archivos anteriores
  static const Color accentOrange   = Color(0xFF2E9BC5);
  static const Color orangePale     = Color(0xFFE8F5FD);
  static const Color headerTeal     = Color(0xFF1B5E80);

  static ThemeData get theme => ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: bgGray,
    colorScheme: const ColorScheme.light(primary: accentBlue),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF3F7FB),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: accentBlue, width: 1.5)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: Color(0xFFBDC3CB), fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}