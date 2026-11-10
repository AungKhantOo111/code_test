sealed class HomeEvent {
  const HomeEvent();
}

class LoadHomeDataEvent extends HomeEvent {
  const LoadHomeDataEvent();
}

class RefreshHomeDataEvent extends HomeEvent {
  const RefreshHomeDataEvent();
}

class ConnectivityChangedEvent extends HomeEvent {
  final bool isConnected;
  const ConnectivityChangedEvent(this.isConnected);
}
