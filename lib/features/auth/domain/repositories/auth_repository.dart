import '../../../../core/errors/result.dart';
import '../models/user.dart';

abstract interface class AuthRepository {
  /// Checks whether a phone number has already been registered
  Future<Result<bool, AuthFailure>> isPhoneRegistered(String normalizedPhone);

  /// Triggers sending a 6-digit OTP to the phone number
  Future<Result<void, AuthFailure>> sendOtp(String normalizedPhone);

  /// Verifies OTP code for an existing user and retrieves session
  Future<Result<User, AuthFailure>> loginWithOtp({
    required String normalizedPhone,
    required String otp,
  });

  /// Completes full registration flow for a new user
  Future<Result<User, AuthFailure>> register({
    required String normalizedPhone,
    required String firstName,
    String? lastName,
    required DateTime dateOfBirth,
  });

  /// Retrieves the active logged-in user session, or null if logged out
  Future<User?> getCurrentSession();

  /// Logs the user out and clears stored session credentials
  Future<void> logout();
}
