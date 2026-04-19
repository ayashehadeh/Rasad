import 'package:flutter/material.dart';
import 'package:rasad/core/constatnts/app_constants.dart';
import '../../../../../core/theme/theme.dart';
import 'package:rasad/features/home/domain/entities/place_entity.dart';

class NearbyPlaceCard extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback? onTap;

  const NearbyPlaceCard({super.key, required this.place, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusSM),
              child: SizedBox(
                width: 72,
                height: 72,
                child: Image.asset(
                  place.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.backgroundElevated,
                    child: const Icon(
                      Icons.landscape_rounded,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category label
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _categoryColor(place.category).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusFull,
                      ),
                    ),
                    child: Text(
                      place.categoryLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: _categoryColor(place.category),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    place.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 12,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${place.distanceKm} km away',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Rating chip
            Column(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.accentGold,
                  size: 16,
                ),
                const SizedBox(height: 2),
                Text(
                  place.rating.toStringAsFixed(1),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _categoryColor(PlaceCategory cat) {
    switch (cat) {
      case PlaceCategory.history:
        return AppColors.accentGold;
      case PlaceCategory.cuisine:
        return AppColors.primary;
      case PlaceCategory.art:
        return const Color(0xFF7C6EF5);
      case PlaceCategory.nature:
        return AppColors.success;
      case PlaceCategory.adventure:
        return AppColors.warning;
    }
  }
}
