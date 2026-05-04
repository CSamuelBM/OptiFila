import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryDark   = Color(0xFF0D1B2A);
  static const Color headerTeal    = Color(0xFF1B3A50);
  static const Color accentOrange  = Color(0xFFE8A020);
  static const Color orangePale    = Color(0xFFFFF3DC);
  static const Color textPrimary   = Color(0xFF1A2B3C);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight     = Color(0xFF9CA3AF);
  static const Color cardWhite     = Color(0xFFFFFFFF);
  static const Color bgGray        = Color(0xFFF5F7FA);
  static const Color successGreen  = Color(0xFF22C55E);
  static const Color errorRed      = Color(0xFFEF4444);
  static const Color borderColor   = Color(0xFFE5E7EB);

  static ThemeData get theme => ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: bgGray,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.light(primary: accentOrange),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF3F4F6),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: accentOrange, width: 1.5)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: Color(0xFFBDC3CB), fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}