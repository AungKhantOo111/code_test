import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/rewards_repository.dart';
import 'rewards_event.dart';
import 'rewards_state.dart';

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  final RewardsRepository _rewardsRepository;

  RewardsBloc({required RewardsRepository rewardsRepository})
      : _rewardsRepository = rewardsRepository,
        super(const RewardsState()) {
    on<LoadRewardsEvent>(_onLoadRewards);
    on<TabChangedEvent>(_onTabChanged);
    on<EarnChallengeEvent>(_onEarnChallenge);
  }

  Future<void> _onLoadRewards(
    LoadRewardsEvent event,
    Emitter<RewardsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _rewardsRepository.getRewardsData();
    result.fold(
      onSuccess: (data) {
        emit(state.copyWith(isLoading: false, data: data));
      },
      onFailure: (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
    );
  }

  void _onTabChanged(
    TabChangedEvent event,
    Emitter<RewardsState> emit,
  ) {
    if (state.selectedTabIndex == event.tabIndex) return;
    emit(state.copyWith(
      selectedTabIndex: event.tabIndex,
      clearLastClaimed: true,
    ));
  }

  void _onEarnChallenge(
    EarnChallengeEvent event,
    Emitter<RewardsState> emit,
  ) {
    // PDF requirement: "No button needs logic: Rewards, Earn and the Gift tab only need visual feedback."
    final updated = Set<String>.from(state.claimedChallengeIds)..add(event.challengeId);
    emit(state.copyWith(
      claimedChallengeIds: updated,
      lastClaimedId: event.challengeId,
    ));
  }
}
