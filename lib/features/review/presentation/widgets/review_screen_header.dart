import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';
import '../../../auth/presentation/widgets/widgets.dart';

/// Top bar used in the review flow: back button + centered brand logo.
class ReviewScreenHeader extends StatelessWidget {
  final VoidCallback? onBack;

  const ReviewScreenHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const Spacer(),
        const RasadBrandHeader(showTagline: false, logoSize: 36),
        const Spacer(),
        const SizedBox(width: 40), // visual balance
      ],
    );
  }
}
