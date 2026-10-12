import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark Cyberpunk / Obsidian Theme Palette
  static const Color background = Color(0xFF090C15);
  static const Color surface = Color(0xFF121824);
  static const Color surfaceLight = Color(0xFF1E2638);
  
  // Brand Colors
  static const Color primaryCyan = Color(0xFF00E5FF);
  static const Color connectedEmerald = Color(0xFF00E676);
  static const Color warningOrange = Color(0xFFFF9100);
  static const Color errorRed = Color(0xFFFF3D00);
  static const Color goldPremium = Color(0xFFFFD700);

  // Text Colors
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryCyan,
      cardColor: surface,
      colorScheme: const ColorScheme.dark(
        primary: primaryCyan,
        secondary: connectedEmerald,
        surface: surface,
        error: errorRed,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: GoogleFonts.outfit(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      textTheme: GoogleFonts.outfitTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.outfit(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.outfit(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.outfit(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: textPrimary,
          fontSize: 15,
        ),
        bodyMedium: GoogleFonts.outfit(
          color: textSecondary,
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryCyan,
        unselectedItemColor: textMuted,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
      dividerColor: surfaceLight,
      useMaterial3: true,
    );
  }
}
