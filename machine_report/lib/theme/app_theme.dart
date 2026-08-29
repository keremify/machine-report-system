import 'package:flutter/material.dart';
import '../models/failure_report.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF4F46E5); // Tech Indigo
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color primaryLight = Color(0xFFEEF2FF);
  
  static const Color slateDark = Color(0xFF0F172A);
  static const Color slateMedium = Color(0xFF334155);
  static const Color slateLight = Color(0xFF64748B);
  static const Color slateBorder = Color(0xFFE2E8F0);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardSurface = Colors.white;

  // Failure Type Semantic Colors
  static const Color mechanicalColor = Color(0xFFE11D48); // Vibrant Rose
  static const Color electricalColor = Color(0xFFD97706); // Amber
  static const Color hydraulicColor = Color(0xFF0D9488);  // Teal
  static const Color softwareColor = Color(0xFF0284C7);   // Cyan/Blue

  static Color getTypeColor(FailureType type) {
    switch (type) {
      case FailureType.mechanical:
        return mechanicalColor;
      case FailureType.electrical:
        return electricalColor;
      case FailureType.hydraulic:
        return hydraulicColor;
      case FailureType.software:
        return softwareColor;
    }
  }

  static IconData getTypeIcon(FailureType type) {
    switch (type) {
      case FailureType.mechanical:
        return Icons.settings_rounded;
      case FailureType.electrical:
        return Icons.bolt_rounded;
      case FailureType.hydraulic:
        return Icons.water_drop_rounded;
      case FailureType.software:
        return Icons.code_rounded;
    }
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        surface: backgroundLight,
        onSurface: slateDark,
        surfaceContainerHighest: Color(0xFFF1F5F9),
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: slateDark,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
        titleTextStyle: TextStyle(
          color: slateDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: slateBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: slateBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: slateBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.8),
        ),
        labelStyle: const TextStyle(color: slateLight, fontSize: 14),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: slateDark,
          side: const BorderSide(color: slateBorder),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: slateBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
