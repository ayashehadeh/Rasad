import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/reward_entity.dart';
import 'rewards_event.dart';
import 'rewards_state.dart';

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  RewardsBloc() : super(const RewardsInitial()) {
    on<RewardsLoadRequested>(_onLoadRequested);
    on<RewardRedeemRequested>(_onRedeemRequested);
  }

  Future<void> _onLoadRequested(
    RewardsLoadRequested event,
    Emitter<RewardsState> emit,
  ) async {
    emit(const RewardsLoading());
    await Future<void>.delayed(const Duration(milliseconds: 300));
    emit(
      RewardsLoaded(
        userPoints: 1200,
        rewards: _seedRewards,
        recentActivity: _seedActivity,
      ),
    );
  }

  Future<void> _onRedeemRequested(
    RewardRedeemRequested event,
    Emitter<RewardsState> emit,
  ) async {
    final stateValue = state;
    if (stateValue is! RewardsLoaded) return;

    RewardEntity? reward;
    for (final item in stateValue.rewards) {
      if (item.id == event.rewardId) {
        reward = item;
        break;
      }
    }
    if (reward == null || !reward.isAvailable) return;
    if (stateValue.userPoints < reward.pointsCost) return;

    emit(stateValue.copyWith(redeemingRewardId: reward.id, clearSuccessMessage: true));
    await Future<void>.delayed(const Duration(milliseconds: 500));

    emit(
      stateValue.copyWith(
        userPoints: stateValue.userPoints - reward.pointsCost,
        recentActivity: [
          ActivityEntity(
            title: 'Redeemed ${reward.title}',
            points: reward.pointsCost,
            isEarned: false,
            date: DateTime.now(),
          ),
          ...stateValue.recentActivity,
        ],
        redeemingRewardId: null,
        successMessage: '${reward.title} redeemed successfully.',
      ),
    );
  }
}

const _seedRewards = [
  RewardEntity(
    id: 'r1',
    title: 'Petra Entry Voucher',
    description: 'Discount voucher for Petra ticket.',
    category: 'Attractions',
    imageEmoji: '🏛️',
    pointsCost: 800,
  ),
  RewardEntity(
    id: 'r2',
    title: 'Wadi Rum Jeep Tour',
    description: '50% off selected desert tours.',
    category: 'Adventure',
    imageEmoji: '🏜️',
    pointsCost: 950,
  ),
  RewardEntity(
    id: 'r3',
    title: 'Dead Sea Spa Pass',
    description: 'One day wellness pass.',
    category: 'Wellness',
    imageEmoji: '🧖',
    pointsCost: 700,
  ),
];

final _seedActivity = [
  ActivityEntity(
    title: 'Visited Jerash',
    points: 120,
    isEarned: true,
    date: DateTime.now().subtract(const Duration(days: 1)),
  ),
  ActivityEntity(
    title: 'Completed city tour challenge',
    points: 80,
    isEarned: true,
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
];
