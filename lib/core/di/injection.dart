import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/network_info.dart';
import '../storage/app_database.dart';
import '../../features/auth/data/repositories/fake_auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/presentation/bloc/product_detail_bloc.dart';
import '../../features/rewards/data/repositories/rewards_repository_impl.dart';
import '../../features/rewards/domain/repositories/rewards_repository.dart';
import '../../features/rewards/presentation/bloc/rewards_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Core Storage & Network
  if (!sl.isRegistered<AppDatabase>()) {
    sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  }
  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  }

  // 2. Repositories
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => FakeAuthRepositoryImpl(
        storage: const FlutterSecureStorage(),
        delay: const Duration(milliseconds: 800),
      ),
    );
  }
  if (!sl.isRegistered<HomeRepository>()) {
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(db: sl<AppDatabase>()),
    );
  }
  if (!sl.isRegistered<ProductRepository>()) {
    sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(homeRepository: sl<HomeRepository>()),
    );
  }
  if (!sl.isRegistered<RewardsRepository>()) {
    sl.registerLazySingleton<RewardsRepository>(
      () => RewardsRepositoryImpl(db: sl<AppDatabase>()),
    );
  }

  // 3. BLoCs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: sl<AuthRepository>()),
  );
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(
      homeRepository: sl<HomeRepository>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerFactory<ProductDetailBloc>(
    () => ProductDetailBloc(productRepository: sl<ProductRepository>()),
  );
  sl.registerFactory<RewardsBloc>(
    () => RewardsBloc(rewardsRepository: sl<RewardsRepository>()),
  );
}
