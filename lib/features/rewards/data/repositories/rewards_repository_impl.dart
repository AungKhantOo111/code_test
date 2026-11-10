import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../../core/errors/result.dart';
import '../../../../core/storage/app_database.dart';
import '../../domain/models/reward_models.dart';
import '../../domain/repositories/rewards_repository.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final AppDatabase _db;

  RewardsRepositoryImpl({required AppDatabase db}) : _db = db;

  Future<void> _seedChallengesIfEmpty() async {
    try {
      final jsonString = await rootBundle.loadString('assets/seed/initial_data.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      if (data['challenges'] != null) {
        final challenges = data['challenges'] as List;
        await _db.batch((batch) {
          for (final c in challenges) {
            batch.insert(
              _db.challengesTable,
              ChallengesTableCompanion.insert(
                id: c['id'] as String,
                title: c['title'] as String,
                current: c['current'] as int,
                target: c['target'] as int,
                rewardPoints: c['rewardPoints'] as int,
                type: c['type'] as String,
                imageUrl: c['imageUrl'] as String,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        });
      }
    } catch (_) {}
  }

  @override
  Future<Result<RewardsData, Failure>> getRewardsData() async {
    try {
      await _seedChallengesIfEmpty();

      final members = await _db.select(_db.memberProfilesTable).get();
      final challengeRows = await _db.select(_db.challengesTable).get();

      final member = members.isNotEmpty ? members.first : null;
      final totalPoints = member?.totalPoints ?? 680000;
      final tier = member?.tier ?? 'Silver';
      final pointsToNext = member?.pointsToNextTier ?? 500;
      final unread = member?.unreadNotifications ?? 3;

      final tiers = [
        TierInfo(
          name: 'Silver',
          subtitle: "You're here now",
          isCurrent: tier.toLowerCase() == 'silver',
          isReached: true,
          progressToNext: 0.72,
        ),
        TierInfo(
          name: 'Gold',
          subtitle: '$pointsToNext pts Remaining to become Gold',
          isCurrent: tier.toLowerCase() == 'gold',
          isReached: tier.toLowerCase() == 'gold' || tier.toLowerCase() == 'platinum',
          progressToNext: 0.0,
        ),
        TierInfo(
          name: 'Platinum',
          subtitle: "You'll be here soon",
          isCurrent: tier.toLowerCase() == 'platinum',
          isReached: tier.toLowerCase() == 'platinum',
          progressToNext: 0.0,
        ),
      ];

      final challenges = challengeRows.map((row) {
        return ChallengeItem(
          id: row.id,
          title: row.title,
          current: row.current,
          target: row.target,
          rewardPoints: row.rewardPoints,
          type: row.type,
          imageUrl: row.imageUrl,
        );
      }).toList();

      return Success(
        RewardsData(
          memberTier: tier,
          totalPoints: totalPoints,
          pointsToNextTier: pointsToNext,
          unreadNotifications: unread,
          tiers: tiers,
          challenges: challenges,
        ),
      );
    } catch (e) {
      return Error(StorageFailure('Failed to load rewards data: $e'));
    }
  }

  @override
  Stream<RewardsData> watchRewardsData() {
    return _db.select(_db.challengesTable).watch().asyncMap((_) async {
      final res = await getRewardsData();
      return res.dataOrNull ??
          const RewardsData(
            memberTier: 'Silver',
            totalPoints: 680000,
            pointsToNextTier: 500,
            unreadNotifications: 3,
            tiers: [],
            challenges: [],
          );
    });
  }
}
