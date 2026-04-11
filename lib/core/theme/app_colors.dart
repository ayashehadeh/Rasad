import 'package:flutter/material.dart';

/// Rasad - Jordan Eye color palette
/// Inspired by Jordan's landscape: crimson desert, warm sand, deep night sky
abstract class AppColors {
  // Primary — Deep Crimson (brand red)
  static const Color primary = Color(0xFFBE1E2D);
  static const Color primaryDark = Color(0xFF8B0000);
  static const Color primaryLight = Color(0xFFE53935);

  // Background
  static const Color backgroundDark = Color(0xFF0D0D0D);
  static const Color backgroundCard = Color(0xFF1A1A1A);
  static const Color backgroundElevated = Color(0xFF242424);
  static const Color backgroundSurface = Color(0xFF2C2C2C);

  // Text
  static const Color textPrimary = Color(0xFFF5F0E8); // warm white
  static const Color textSecondary = Color(0xFFB0A898); // warm grey
  static const Color textHint = Color(0xFF6B6460);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Accent — warm sand tones
  static const Color accentGold = Color(0xFFD4A853);
  static const Color accentSand = Color(0xFFC8A97A);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);

  // Border / Divider
  static const Color border = Color(0xFF3A3530);
  static const Color divider = Color(0xFF2A2520);

  // Overlay
  static const Color overlayDark = Color(0xCC000000);
  static const Color shimmer = Color(0xFF2E2E2E);
  static const Color shimmerHighlight = Color(0xFF3D3D3D);
}
