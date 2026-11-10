import 'package:flutter_test/flutter_test.dart';
import 'package:code_test/core/errors/result.dart';
import 'package:code_test/features/rewards/domain/models/reward_models.dart';
import 'package:code_test/features/rewards/domain/repositories/rewards_repository.dart';
import 'package:code_test/features/rewards/presentation/bloc/rewards_bloc.dart';
import 'package:code_test/features/rewards/presentation/bloc/rewards_event.dart';

class MockRewardsRepository implements RewardsRepository {
  final RewardsData stubData;

  MockRewardsRepository(this.stubData);

  @override
  Future<Result<RewardsData, Failure>> getRewardsData() async {
    return Success(stubData);
  }

  @override
  Stream<RewardsData> watchRewardsData() {
    return Stream.value(stubData);
  }
}

void main() {
  group('RewardsBloc tests', () {
    late RewardsBloc bloc;
    late MockRewardsRepository mockRepo;

    const testData = RewardsData(
      memberTier: 'Silver',
      totalPoints: 680000,
      pointsToNextTier: 500,
      unreadNotifications: 3,
      tiers: [
        TierInfo(name: 'Silver', subtitle: "You're here now", isCurrent: true),
        TierInfo(name: 'Gold', subtitle: "500 pts Remaining to become Gold", isCurrent: false),
        TierInfo(name: 'Platinum', subtitle: "You'll be here soon", isCurrent: false),
      ],
      challenges: [
        ChallengeItem(
          id: 'c_001',
          title: 'Eat 4 Coco donuts',
          current: 4,
          target: 4,
          rewardPoints: 100,
          type: 'donut',
          imageUrl: 'assets/images/7.png',
        ),
      ],
    );

    setUp(() {
      mockRepo = MockRewardsRepository(testData);
      bloc = RewardsBloc(rewardsRepository: mockRepo);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state has isLoading true and tab index 0', () {
      expect(bloc.state.isLoading, isTrue);
      expect(bloc.state.selectedTabIndex, equals(0));
      expect(bloc.state.data, isNull);
    });

    test('LoadRewardsEvent emits loaded state with data', () async {
      bloc.add(const LoadRewardsEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<dynamic>((s) => s.isLoading == true),
          predicate<dynamic>((s) => s.isLoading == false && s.data?.totalPoints == 680000),
        ]),
      );
    });

    test('TabChangedEvent switches between tab 0 and 1', () async {
      bloc.add(const TabChangedEvent(1));

      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((s) => s.selectedTabIndex == 1)),
      );

      bloc.add(const TabChangedEvent(0));
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((s) => s.selectedTabIndex == 0)),
      );
    });

    test('EarnChallengeEvent updates claimedChallengeIds and triggers feedback', () async {
      bloc.add(const EarnChallengeEvent('c_001'));

      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((s) =>
            s.claimedChallengeIds.contains('c_001') && s.lastClaimedId == 'c_001')),
      );
    });
  });
}
