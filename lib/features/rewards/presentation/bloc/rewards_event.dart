abstract class RewardsEvent {
  const RewardsEvent();
}

class LoadRewardsEvent extends RewardsEvent {
  const LoadRewardsEvent();
}

class TabChangedEvent extends RewardsEvent {
  final int tabIndex;
  const TabChangedEvent(this.tabIndex);
}

class EarnChallengeEvent extends RewardsEvent {
  final String challengeId;
  const EarnChallengeEvent(this.challengeId);
}
