import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rasad/app_router.dart';
import '../../../../core/constatnts/app_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../home/presentation/widgets/home_nav_bar.dart';
import '../../domain/entities/reward_entity.dart';
import '../bloc/rewards_bloc.dart';
import '../bloc/rewards_event.dart';
import '../bloc/rewards_state.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  HomeNavTab _currentTab = HomeNavTab.rewards;

  @override
  void initState() {
    super.initState();
    context.read<RewardsBloc>().add(const RewardsLoadRequested());
  }

  void _onTabChanged(HomeNavTab tab) {
    setState(() => _currentTab = tab);

    if (tab == HomeNavTab.home) {
      context.go(AppRoutes.home);
      return;
    }

    if (tab == HomeNavTab.explore) {
      context.go(AppRoutes.explore);
      return;
    }

    if (tab == HomeNavTab.add) {
      context.push(
        AppRoutes.review,
        extra: const {
          'placeId': 'petra',
          'placeName': 'The Treasury, Petra',
          'userId': 'guest-user',
          'returnRoute': AppRoutes.rewards,
        },
      );
      return;
    }

    if (tab == HomeNavTab.rewards) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This section is coming soon.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RewardsBloc, RewardsState>(
      listener: (context, state) {
        if (state is RewardsLoaded && state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.successMessage!)),
          );
        }
      },
      builder: (context, state) {
        if (state is RewardsLoading || state is RewardsInitial) {
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
            bottomNavigationBar: HomeNavBar(
              currentTab: _currentTab,
              onTabChanged: _onTabChanged,
            ),
          );
        }

        if (state is RewardsFailure) {
          return Scaffold(
            body: Center(child: Text(state.message)),
            bottomNavigationBar: HomeNavBar(
              currentTab: _currentTab,
              onTabChanged: _onTabChanged,
            ),
          );
        }

        if (state is RewardsLoaded) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            appBar: AppBar(
              title: Text('Rewards', style: AppTextStyles.headlineMedium),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    child: Text(
                      '${state.userPoints} pts',
                      style: AppTextStyles.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
            body: GridView.builder(
              padding: const EdgeInsets.all(AppConstants.spaceMD),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: state.rewards.length,
              itemBuilder: (context, index) {
                final reward = state.rewards[index];
                return _RewardCard(
                  reward: reward,
                  points: state.userPoints,
                  isRedeeming: state.redeemingRewardId == reward.id,
                  onRedeem: () => context.read<RewardsBloc>().add(
                        RewardRedeemRequested(reward.id),
                      ),
                );
              },
            ),
            bottomNavigationBar: HomeNavBar(
              currentTab: _currentTab,
              onTabChanged: _onTabChanged,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _RewardCard extends StatelessWidget {
  final RewardEntity reward;
  final int points;
  final bool isRedeeming;
  final VoidCallback onRedeem;

  const _RewardCard({
    required this.reward,
    required this.points,
    required this.isRedeeming,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final canRedeem = reward.isAvailable && points >= reward.pointsCost;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(reward.imageEmoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 8),
          Text(reward.title, maxLines: 2, overflow: TextOverflow.ellipsis),
          const Spacer(),
          Text('${reward.pointsCost} pts'),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canRedeem && !isRedeeming ? onRedeem : null,
              child: isRedeeming
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Redeem'),
            ),
          ),
        ],
      ),
    );
  }
}
