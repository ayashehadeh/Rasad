import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

/// Subtle geometric background inspired by Jordan's desert landscape and Petra
class JordanBackgroundDecoration extends StatelessWidget {
  final Widget child;

  const JordanBackgroundDecoration({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base background
        Container(color: AppColors.backgroundDark),

        // Top gradient radial glow (red, like setting sun over Wadi Rum)
        Positioned(
          top: -100,
          right: -80,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.18),
                  AppColors.primary.withValues(alpha: 0.04),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Bottom left subtle glow (warm sand)
        Positioned(
          bottom: -60,
          left: -60,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentGold.withValues(alpha: 0.10),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Geometric lines — like Nabataean architectural patterns
        Positioned.fill(child: CustomPaint(painter: _PatternPainter())),

        // Content
        child,
      ],
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.25)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Subtle diagonal lines (top-right corner)
    for (int i = 0; i < 6; i++) {
      final offset = i * 28.0;
      canvas.drawLine(
        Offset(size.width - 20 - offset, 0),
        Offset(size.width, 20 + offset),
        paint,
      );
    }

    // Subtle diagonal lines (bottom-left corner)
    for (int i = 0; i < 5; i++) {
      final offset = i * 28.0;
      canvas.drawLine(
        Offset(0, size.height - 20 - offset),
        Offset(20 + offset, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_PatternPainter oldDelegate) => false;
}
