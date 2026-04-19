import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';
import 'package:rasad/features/home/domain/entities/place_entity.dart';
import 'package:rasad/core/constatnts/app_constants.dart';

class TrendingPlaceCard extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback? onTap;

  const TrendingPlaceCard({super.key, required this.place, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Place image
              Image.asset(
                place.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.backgroundElevated,
                  child: const Icon(
                    Icons.landscape_rounded,
                    color: AppColors.textHint,
                    size: 48,
                  ),
                ),
              ),

              // Dark gradient overlay (bottom)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.25),
                        Colors.black.withOpacity(0.85),
                      ],
                      stops: const [0.35, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // Category badge (top-left)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusFull,
                    ),
                  ),
                  child: Text(
                    place.categoryLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),

              // Trending indicator (top-right)
              if (place.isTrending)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.accentGold,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGold.withOpacity(0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.backgroundDark,
                      size: 16,
                    ),
                  ),
                ),

              // Place name + rating (bottom)
              Positioned(
                left: 12,
                right: 12,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textOnPrimary,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.accentGold,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          place.rating.toStringAsFixed(1),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
