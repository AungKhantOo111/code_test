import '../../../../core/errors/result.dart';
import '../models/reward_models.dart';

abstract class RewardsRepository {
  Future<Result<RewardsData, Failure>> getRewardsData();
  Stream<RewardsData> watchRewardsData();
}
