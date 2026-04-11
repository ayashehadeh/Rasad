import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class RasadBrandHeader extends StatelessWidget {
  final bool showTagline;
  final double logoSize;

  const RasadBrandHeader({
    super.key,
    this.showTagline = true,
    this.logoSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(logoSize * 0.25),
          ),
          child: Center(
            child: Text(
              'R',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: logoSize * 0.55,
                fontWeight: FontWeight.w800,
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text('Rasad', style: AppTextStyles.displayMedium),
        if (showTagline) ...[
          const SizedBox(height: 2),
          Text(
            'Jordan Eye',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.accentGold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}
