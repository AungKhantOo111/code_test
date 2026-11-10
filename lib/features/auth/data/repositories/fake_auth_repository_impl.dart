import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/errors/result.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/validators/auth_validators.dart';

class FakeAuthRepositoryImpl implements AuthRepository {
  final FlutterSecureStorage? _storage;
  final Duration delay;
  User? _currentSession;

  static const String _keyActiveUser = 'active_user_session';
  static const String _keyRegisteredUsers = 'registered_users_db';

  // In-memory cache of registered users, seeded with default mock user
  final Map<String, User> _registeredUsers = {};

  FakeAuthRepositoryImpl({
    FlutterSecureStorage? storage,
    this.delay = const Duration(milliseconds: 300),
  })  : _storage = storage {
    _initDefaultUser();
  }

  Future<void> _simulateDelay() async {
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }
  }

  void _initDefaultUser() {
    // Default test user matching the design mock-up (Hania, Bronze member)
    final defaultUser = User(
      id: 'user_001',
      phone: '+959254135592',
      firstName: 'Hania',
      lastName: '',
      dateOfBirth: DateTime(1995, 5, 12),
      tier: 'Bronze',
      points: 1290,
    );
    _registeredUsers[defaultUser.phone] = defaultUser;
  }

  Future<void> _loadFromStorage() async {
    if (_storage == null) return;
    try {
      final raw = await _storage.read(key: _keyRegisteredUsers);
      if (raw != null && raw.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(raw);
        decoded.forEach((key, value) {
          _registeredUsers[key] = User.fromJson(value as Map<String, dynamic>);
        });
      }
    } catch (_) {
      // Keep in-memory cache fallback
    }
  }

  Future<void> _saveToStorage() async {
    if (_storage == null) return;
    try {
      final map = _registeredUsers.map((key, val) => MapEntry(key, val.toJson()));
      await _storage.write(key: _keyRegisteredUsers, value: jsonEncode(map));
    } catch (_) {}
  }

  @override
  Future<Result<bool, AuthFailure>> isPhoneRegistered(String normalizedPhone) async {
    await _simulateDelay();
    await _loadFromStorage();
    final isRegistered = _registeredUsers.containsKey(normalizedPhone);
    return Success(isRegistered);
  }

  @override
  Future<Result<void, AuthFailure>> sendOtp(String normalizedPhone) async {
    await _simulateDelay();
    return const Success(null);
  }

  @override
  Future<Result<User, AuthFailure>> loginWithOtp({
    required String normalizedPhone,
    required String otp,
  }) async {
    await _simulateDelay();
    await _loadFromStorage();

    if (!OtpValidator.validate(otp)) {
      return const Error(AuthFailure('Invalid code. The test pass code is 123456.'));
    }

    final user = _registeredUsers[normalizedPhone];
    if (user == null) {
      return const Error(
        AuthFailure('This phone number is not registered yet. Please create an account.'),
      );
    }

    // Save session
    _currentSession = user;
    if (_storage != null) {
      try {
        await _storage.write(key: _keyActiveUser, value: jsonEncode(user.toJson()));
      } catch (_) {}
    }
    return Success(user);
  }

  @override
  Future<Result<User, AuthFailure>> register({
    required String normalizedPhone,
    required String firstName,
    String? lastName,
    required DateTime dateOfBirth,
  }) async {
    await _simulateDelay();
    await _loadFromStorage();

    final newUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      phone: normalizedPhone,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      tier: 'Bronze',
      points: 1290,
    );

    _registeredUsers[normalizedPhone] = newUser;
    await _saveToStorage();
    _currentSession = newUser;
    if (_storage != null) {
      try {
        await _storage.write(key: _keyActiveUser, value: jsonEncode(newUser.toJson()));
      } catch (_) {}
    }

    return Success(newUser);
  }

  @override
  Future<User?> getCurrentSession() async {
    if (_storage != null) {
      try {
        final raw = await _storage.read(key: _keyActiveUser);
        if (raw != null && raw.isNotEmpty) {
          _currentSession = User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        }
      } catch (_) {}
    }
    return _currentSession;
  }

  @override
  Future<void> logout() async {
    _currentSession = null;
    if (_storage != null) {
      try {
        await _storage.delete(key: _keyActiveUser);
      } catch (_) {}
    }
  }
}
