class ChallengeItem {
  final String id;
  final String title;
  final int current;
  final int target;
  final int rewardPoints;
  final String type; // 'donut' or 'coffee'
  final String imageUrl;

  const ChallengeItem({
    required this.id,
    required this.title,
    required this.current,
    required this.target,
    required this.rewardPoints,
    required this.type,
    required this.imageUrl,
  });

  bool get isComplete => current >= target;
  double get progress => target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
  String get progressText => '$current/$target';
}

class TierInfo {
  final String name;
  final String subtitle;
  final bool isCurrent;
  final bool isReached;
  final double progressToNext; // 0.0 to 1.0

  const TierInfo({
    required this.name,
    required this.subtitle,
    required this.isCurrent,
    this.isReached = false,
    this.progressToNext = 0.0,
  });
}

class RewardsData {
  final String memberTier;
  final int totalPoints;
  final int pointsToNextTier;
  final int unreadNotifications;
  final List<TierInfo> tiers;
  final List<ChallengeItem> challenges;

  const RewardsData({
    required this.memberTier,
    required this.totalPoints,
    required this.pointsToNextTier,
    required this.unreadNotifications,
    required this.tiers,
    required this.challenges,
  });
}
