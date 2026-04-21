import 'package:flutter/material.dart';
import 'package:rasad/core/constatnts/app_constants.dart';
import 'package:rasad/core/theme/theme.dart';
import '../../domain/entities/explore_place_entity.dart';

class ExplorePlaceCard extends StatelessWidget {
  final ExplorePlaceEntity place;
  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;

  const ExplorePlaceCard({
    super.key,
    required this.place,
    this.onTap,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppConstants.radiusLG),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  place.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.backgroundElevated,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                        ),
                        child: Text(
                          place.categoryLabel,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          place.location,
                          style: AppTextStyles.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spaceXS),
                  Text(place.name, style: AppTextStyles.headlineSmall),
                  const SizedBox(height: AppConstants.spaceXS),
                  Text(
                    place.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceSM),
                  TextButton(
                    onPressed: onViewDetails,
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text('View details'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
