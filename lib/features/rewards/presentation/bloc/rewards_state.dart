import '../../domain/models/reward_models.dart';

class RewardsState {
  final bool isLoading;
  final RewardsData? data;
  final int selectedTabIndex; // 0: Eat more earn more, 1: Gift
  final Set<String> claimedChallengeIds;
  final String? lastClaimedId;
  final String? errorMessage;

  const RewardsState({
    this.isLoading = true,
    this.data,
    this.selectedTabIndex = 0,
    this.claimedChallengeIds = const {},
    this.lastClaimedId,
    this.errorMessage,
  });

  RewardsState copyWith({
    bool? isLoading,
    RewardsData? data,
    int? selectedTabIndex,
    Set<String>? claimedChallengeIds,
    String? lastClaimedId,
    bool clearLastClaimed = false,
    String? errorMessage,
  }) {
    return RewardsState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      claimedChallengeIds: claimedChallengeIds ?? this.claimedChallengeIds,
      lastClaimedId: clearLastClaimed ? null : (lastClaimedId ?? this.lastClaimedId),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
