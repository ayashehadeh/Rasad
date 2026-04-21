import '../../domain/entities/reward_entity.dart';

abstract class RewardsState {
  const RewardsState();
}

class RewardsInitial extends RewardsState {
  const RewardsInitial();
}

class RewardsLoading extends RewardsState {
  const RewardsLoading();
}

class RewardsFailure extends RewardsState {
  final String message;
  const RewardsFailure(this.message);
}

class RewardsLoaded extends RewardsState {
  final int userPoints;
  final List<RewardEntity> rewards;
  final List<ActivityEntity> recentActivity;
  final String? redeemingRewardId;
  final String? successMessage;

  const RewardsLoaded({
    required this.userPoints,
    required this.rewards,
    required this.recentActivity,
    this.redeemingRewardId,
    this.successMessage,
  });

  RewardsLoaded copyWith({
    int? userPoints,
    List<RewardEntity>? rewards,
    List<ActivityEntity>? recentActivity,
    String? redeemingRewardId,
    String? successMessage,
    bool clearSuccessMessage = false,
  }) {
    return RewardsLoaded(
      userPoints: userPoints ?? this.userPoints,
      rewards: rewards ?? this.rewards,
      recentActivity: recentActivity ?? this.recentActivity,
      redeemingRewardId: redeemingRewardId,
      successMessage:
          clearSuccessMessage ? null : (successMessage ?? this.successMessage),
    );
  }
}
