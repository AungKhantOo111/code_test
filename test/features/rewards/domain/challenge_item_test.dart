import 'package:flutter_test/flutter_test.dart';
import 'package:code_test/features/rewards/domain/models/reward_models.dart';

void main() {
  group('ChallengeItem domain model tests', () {
    test('calculates completion correctly when current equals target', () {
      const challenge = ChallengeItem(
        id: 'c_001',
        title: 'Eat 4 Coco donuts',
        current: 4,
        target: 4,
        rewardPoints: 100,
        type: 'donut',
        imageUrl: 'assets/images/2.png',
      );

      expect(challenge.isComplete, isTrue);
      expect(challenge.progress, equals(1.0));
      expect(challenge.progressText, equals('4/4'));
    });

    test('calculates partial progress correctly (1/4)', () {
      const challenge = ChallengeItem(
        id: 'c_002',
        title: 'Eat 4 Coco donuts',
        current: 1,
        target: 4,
        rewardPoints: 100,
        type: 'donut',
        imageUrl: 'assets/images/5.png',
      );

      expect(challenge.isComplete, isFalse);
      expect(challenge.progress, equals(0.25));
      expect(challenge.progressText, equals('1/4'));
    });

    test('calculates 9/12 progress correctly for coffee challenge', () {
      const challenge = ChallengeItem(
        id: 'c_003',
        title: 'Drink 12 cups americano',
        current: 9,
        target: 12,
        rewardPoints: 100,
        type: 'coffee',
        imageUrl: 'assets/images/one.png',
      );

      expect(challenge.isComplete, isFalse);
      expect(challenge.progress, closeTo(0.75, 0.001));
      expect(challenge.progressText, equals('9/12'));
    });
  });
}
