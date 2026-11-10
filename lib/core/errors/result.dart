sealed class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection unavailable']);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

/// Functional Result type representing either Success or Failure
sealed class Result<S, E extends Failure> {
  const Result();

  bool get isSuccess => this is Success<S, E>;
  bool get isFailure => this is Error<S, E>;

  S? get dataOrNull => switch (this) {
        Success(data: final d) => d,
        Error() => null,
      };

  E? get failureOrNull => switch (this) {
        Success() => null,
        Error(failure: final f) => f,
      };

  R fold<R>({
    required R Function(S data) onSuccess,
    required R Function(E failure) onFailure,
  }) {
    return switch (this) {
      Success(data: final d) => onSuccess(d),
      Error(failure: final f) => onFailure(f),
    };
  }
}

class Success<S, E extends Failure> extends Result<S, E> {
  final S data;
  const Success(this.data);
}

class Error<S, E extends Failure> extends Result<S, E> {
  final E failure;
  const Error(this.failure);
}
