import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';
import 'package:rasad/core/constatnts/app_constants.dart';

/// A single shimmer placeholder matching TrendingPlaceCard dimensions.
class TrendingPlaceCardSkeleton extends StatefulWidget {
  const TrendingPlaceCardSkeleton({super.key});

  @override
  State<TrendingPlaceCardSkeleton> createState() =>
      _TrendingPlaceCardSkeletonState();
}

class _TrendingPlaceCardSkeletonState extends State<TrendingPlaceCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _shimmer = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (_, __) {
        return Container(
          width: 220,
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  AppColors.shimmer,
                  AppColors.shimmerHighlight,
                  _shimmer.value,
                )!,
                Color.lerp(
                  AppColors.shimmerHighlight,
                  AppColors.shimmer,
                  _shimmer.value,
                )!,
              ],
            ),
          ),
        );
      },
    );
  }
}
