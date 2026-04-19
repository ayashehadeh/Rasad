import 'package:flutter/material.dart';
import 'package:rasad/core/constatnts/app_constants.dart';
import '../../../../../core/theme/theme.dart';

/// Top section of the home screen:
/// - User avatar + greeting + name
/// - Points badge (top-right)
class HomeAppBar extends StatelessWidget {
  final String userName;
  final int points;
  final String userLevel;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onPointsTap;

  const HomeAppBar({
    super.key,
    required this.userName,
    required this.points,
    this.userLevel = 'Gold Explorer',
    this.onAvatarTap,
    this.onPointsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        GestureDetector(
          onTap: onAvatarTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundElevated,
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Greeting + level badge
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ahlan, $userName',
                style: AppTextStyles.headlineSmall,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentGold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    userLevel.toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.accentGold,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Points badge
        GestureDetector(
          onTap: onPointsTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_formatPoints(points)} pts',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentGold,
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: AppColors.backgroundDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatPoints(int pts) {
    if (pts >= 1000) {
      return '${(pts / 1000).toStringAsFixed(pts % 1000 == 0 ? 0 : 1)}k';
    }
    return pts.toString();
  }
}
