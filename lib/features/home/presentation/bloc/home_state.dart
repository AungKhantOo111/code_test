import '../../domain/models/home_models.dart';

class HomeState {
  final bool isLoading;
  final bool isRefreshing;
  final bool isOffline;
  final HomeData? homeData;
  final String? errorMessage;

  const HomeState({
    this.isLoading = true,
    this.isRefreshing = false,
    this.isOffline = false,
    this.homeData,
    this.errorMessage,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isOffline,
    HomeData? homeData,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isOffline: isOffline ?? this.isOffline,
      homeData: homeData ?? this.homeData,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
