import 'package:flutter/material.dart';

/// Core color palette for ForgeRoutine.
/// Follows a minimal neumorphic-dark style: deep blacks, subtle elevation, 
/// and neon accents.
class AppColors {
  // Prevent instantiation
  AppColors._();

  // Background Colors
  static const Color bgPrimary = Color(0xFF080808);
  static const Color bgSurface = Color(0xFF111111);
  static const Color bgCard = Color(0xFF181818);
  static const Color bgElevated = Color(0xFF1F1F1F);

  // Accent Colors
  static const Color accentGreen = Color(0xFF00FF9F); // Neon Green
  static const Color accentCyan = Color(0xFF00BFFF);  // Electric Cyan
  static const Color accentRed = Color(0xFFFF4C4C);   // Error/Skipped
  static const Color accentAmber = Color(0xFFFFB347); // Warning/Partial

  // Text Colors
  static const Color textPrimary = Color(0xFFF0F0F0);
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color textMuted = Color(0xFF606060);

  // Functional Colors
  static const Color borderColor = Color(0x0FFFFFFF); // rgba(255,255,255,0.06)
  static const Color shadowColor = Color(0x1400FF9F); // rgba(0,255,159,0.08)

  // Opacity overlays for states
  static Color greenOverlay = accentGreen.withAlpha(25); // ~0.1 opacity
  static Color redOverlay = accentRed.withAlpha(20);     // ~0.08 opacity
  static Color amberOverlay = accentAmber.withAlpha(20); // ~0.08 opacity
}
