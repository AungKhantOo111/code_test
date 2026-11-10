import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final NetworkInfo _networkInfo;
  StreamSubscription<bool>? _connectivitySub;

  HomeBloc({
    required HomeRepository homeRepository,
    required NetworkInfo networkInfo,
  })  : _homeRepository = homeRepository,
        _networkInfo = networkInfo,
        super(const HomeState()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<RefreshHomeDataEvent>(_onRefreshHomeData);
    on<ConnectivityChangedEvent>(_onConnectivityChanged);

    _initConnectivityListener();
    add(const LoadHomeDataEvent());
  }

  void _initConnectivityListener() {
    _connectivitySub = _networkInfo.onConnectivityChanged.listen((isConnected) {
      add(ConnectivityChangedEvent(isConnected));
    });

    // Check initial connectivity
    _networkInfo.isConnected.then((connected) {
      add(ConnectivityChangedEvent(connected));
    });
  }

  Future<void> _onConnectivityChanged(
    ConnectivityChangedEvent event,
    Emitter<HomeState> emit,
  ) async {
    final wasOffline = state.isOffline;
    final isNowOffline = !event.isConnected;

    emit(state.copyWith(isOffline: isNowOffline));

    // When network returns from offline, trigger background refresh
    if (wasOffline && !isNowOffline) {
      add(const RefreshHomeDataEvent());
    }
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _homeRepository.getHomeData();
    result.fold(
      onSuccess: (data) {
        emit(state.copyWith(isLoading: false, homeData: data));
      },
      onFailure: (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
    );
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));

    await _homeRepository.refreshData();
    final result = await _homeRepository.getHomeData();

    result.fold(
      onSuccess: (data) {
        emit(state.copyWith(isRefreshing: false, homeData: data));
      },
      onFailure: (failure) {
        emit(state.copyWith(isRefreshing: false));
      },
    );
  }

  @override
  Future<void> close() {
    _connectivitySub?.cancel();
    return super.close();
  }
}
