abstract class RewardsEvent {
  const RewardsEvent();
}

class RewardsLoadRequested extends RewardsEvent {
  const RewardsLoadRequested();
}

class RewardRedeemRequested extends RewardsEvent {
  final String rewardId;
  const RewardRedeemRequested(this.rewardId);
}
