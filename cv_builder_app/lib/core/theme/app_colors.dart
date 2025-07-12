import 'package:flutter/material.dart';

/// App Color Palette
/// Design System: Light neutral background, Primary navy/teal, Accent mint/aqua
class AppColors {
  AppColors._();

  // Primary Colors - Navy/Teal
  static const Color primary = Color(0xFF006D77);
  static const Color primaryLight = Color(0xFF2A9D8F);
  static const Color primaryDark = Color(0xFF004D56);
  
  // Accent Colors - Mint/Aqua
  static const Color accent = Color(0xFF83C5BE);
  static const Color accentLight = Color(0xFFA8DADC);
  static const Color accentDark = Color(0xFF5A9B94);
  
  // Background Colors - Light neutral
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color borderDark = Color(0xFFD1D5DB);
  
  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x26000000);
  
  // ATS Score Colors
  static const Color atsExcellent = Color(0xFF10B981); // 90-100
  static const Color atsGood = Color(0xFF84CC16);      // 70-89
  static const Color atsFair = Color(0xFFF59E0B);      // 50-69
  static const Color atsPoor = Color(0xFFEF4444);      // 0-49
  
  // Chat Bubble Colors
  static const Color chatUser = primary;
  static const Color chatAI = surfaceVariant;
  static const Color chatUserText = textOnPrimary;
  static const Color chatAIText = textPrimary;
  
  // Template Category Colors
  static const Color templateMinimalist = Color(0xFF6B7280);
  static const Color templateCreative = Color(0xFF8B5CF6);
  static const Color templateCorporate = Color(0xFF1F2937);
  static const Color templateModern = primary;
  static const Color templateAcademic = Color(0xFF059669);
}

/// Material Color Swatches for Theme
class AppColorSwatches {
  AppColorSwatches._();
  
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF006D77,
    <int, Color>{
      50: Color(0xFFE0F2F3),
      100: Color(0xFFB3DFE1),
      200: Color(0xFF80CACD),
      300: Color(0xFF4DB5B9),
      400: Color(0xFF26A5AA),
      500: Color(0xFF006D77),
      600: Color(0xFF00656F),
      700: Color(0xFF005A64),
      800: Color(0xFF00505A),
      900: Color(0xFF003E47),
    },
  );
  
  static const MaterialColor accentSwatch = MaterialColor(
    0xFF83C5BE,
    <int, Color>{
      50: Color(0xFFF0F9F8),
      100: Color(0xFFDAF0ED),
      200: Color(0xFFC2E6E1),
      300: Color(0xFFA9DBD5),
      400: Color(0xFF96D3CC),
      500: Color(0xFF83C5BE),
      600: Color(0xFF7BBFB8),
      700: Color(0xFF70B7B0),
      800: Color(0xFF66AFA8),
      900: Color(0xFF53A199),
    },
  );
}
