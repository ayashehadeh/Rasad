import 'package:flutter/material.dart';

/// Rasad - Jordan Eye color palette
/// Inspired by Jordan's landscape: crimson desert, warm sand, deep night sky
abstract class AppColors {
  // Primary — Deep Crimson (brand red)
  static const Color primary = Color(0xFFBE1E2D);
  static const Color primaryDark = Color(0xFF8B0000);
  static const Color primaryLight = Color(0xFFE53935);

  // Background
  static const Color backgroundDark = Color(0xFFF3F3F3);
  static const Color backgroundCard = Color(0xFFFFFFFF);
  static const Color backgroundElevated = Color(0xFFF8F8F8);
  static const Color backgroundSurface = Color(0xFFE8E8E8);

  // Text
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF6E6E6E);
  static const Color textHint = Color(0xFF9A9A9A);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Accent — warm sand tones
  static const Color accentGold = Color(0xFFD4A853);
  static const Color accentSand = Color(0xFFC8A97A);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);

  // Border / Divider
  static const Color border = Color(0xFFE3E3E3);
  static const Color divider = Color(0xFFECECEC);

  // Overlay
  static const Color overlayDark = Color(0xCC000000);
  static const Color shimmer = Color(0xFFE2E2E2);
  static const Color shimmerHighlight = Color(0xFFF1F1F1);
}
