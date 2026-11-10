import '../../../../core/errors/result.dart';
import '../models/home_models.dart';

abstract interface class HomeRepository {
  /// Seeds initial data from bundled JSON into the local database if not seeded yet
  Future<void> seedInitialDataIfEmpty();

  /// Gets the home aggregate data from the local database (cache/source of truth)
  Future<Result<HomeData, Failure>> getHomeData();

  /// Reactive stream of home data from the local database
  Stream<HomeData> watchHomeData();

  /// Fetches a single product by its id for product detail
  Future<Result<ProductItem, Failure>> getProductById(String id);

  /// Simulates background refresh when connectivity returns or on pull-to-refresh
  Future<Result<void, Failure>> refreshData();
}
