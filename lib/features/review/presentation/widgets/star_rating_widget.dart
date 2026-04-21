import 'package:flutter/material.dart';
import 'package:rasad/core/constatnts/app_constants.dart';
import '../../../../../core/theme/theme.dart';

/// Displays 5 tappable stars and a label describing the current selection.
class StarRatingWidget extends StatelessWidget {
  final int selectedStars;
  final ValueChanged<int> onStarTapped;
  final bool enabled;

  const StarRatingWidget({
    super.key,
    required this.selectedStars,
    required this.onStarTapped,
    this.enabled = true,
  });

  String get _label {
    switch (selectedStars) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent!';
      default:
        return 'Tap to rate';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: AppConstants.animFast,
          child: Text(
            _label,
            key: ValueKey(_label),
            style: AppTextStyles.headlineMedium.copyWith(
              color: selectedStars > 0
                  ? AppColors.accentGold
                  : AppColors.textHint,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final active = i < selectedStars;
            return GestureDetector(
              onTap: enabled ? () => onStarTapped(i + 1) : null,
              child: AnimatedContainer(
                duration: AppConstants.animFast,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  active ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 48,
                  color: active ? AppColors.accentGold : AppColors.border,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
