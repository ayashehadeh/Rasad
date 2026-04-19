import 'package:flutter/material.dart';
import 'package:rasad/core/constatnts/app_constants.dart';
import '../../../../../core/theme/theme.dart';

enum HomeNavTab { home, explore, add, rewards, profile }

class HomeNavBar extends StatelessWidget {
  final HomeNavTab currentTab;
  final ValueChanged<HomeNavTab> onTabChanged;

  const HomeNavBar({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.8)),
      ),
      child: Row(
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            isActive: currentTab == HomeNavTab.home,
            onTap: () => onTabChanged(HomeNavTab.home),
          ),
          _NavItem(
            icon: Icons.explore_rounded,
            label: 'Explore',
            isActive: currentTab == HomeNavTab.explore,
            onTap: () => onTabChanged(HomeNavTab.explore),
          ),

          // Centre FAB-style Add button
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(HomeNavTab.add),
              child: Center(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: AppColors.textOnPrimary,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),

          _NavItem(
            icon: Icons.card_giftcard_rounded,
            label: 'Rewards',
            isActive: currentTab == HomeNavTab.rewards,
            onTap: () => onTabChanged(HomeNavTab.rewards),
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isActive: currentTab == HomeNavTab.profile,
            onTap: () => onTabChanged(HomeNavTab.profile),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textHint;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: AppConstants.animFast,
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
