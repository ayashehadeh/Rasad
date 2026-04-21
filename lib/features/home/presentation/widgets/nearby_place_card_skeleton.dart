import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';
import 'package:rasad/core/constatnts/app_constants.dart';

class NearbyPlaceCardSkeleton extends StatefulWidget {
  const NearbyPlaceCardSkeleton({super.key});

  @override
  State<NearbyPlaceCardSkeleton> createState() =>
      _NearbyPlaceCardSkeletonState();
}

class _NearbyPlaceCardSkeletonState extends State<NearbyPlaceCardSkeleton>
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

  Color get _base => Color.lerp(
    AppColors.shimmer,
    AppColors.shimmerHighlight,
    _shimmer.value,
  )!;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (_, __) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            border: Border.all(color: AppColors.border, width: 0.8),
          ),
          child: Row(
            children: [
              // Image placeholder
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _base,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      width: 60,
                      decoration: BoxDecoration(
                        color: _base,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _base,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 80,
                      decoration: BoxDecoration(
                        color: _base,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
