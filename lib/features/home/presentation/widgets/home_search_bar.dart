import 'package:flutter/material.dart';
import 'package:rasad/core/constatnts/app_constants.dart';
import '../../../../../core/theme/theme.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;

  const HomeSearchBar({super.key, this.onTap, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(
              Icons.search_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search experiences in Jordan',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ),
            // Filter icon
            GestureDetector(
              onTap: onFilterTap,
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSurface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
