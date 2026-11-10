class AppConstants {
  AppConstants._();

  /// Legal minimum age requirement for user registration
  static const int minAgeYears = 13;

  /// Fake OTP code that passes validation
  static const String fakeValidOtp = '123456';

  /// Maximum failed OTP attempts before lock
  static const int maxOtpAttempts = 3;

  /// OTP Resend countdown in seconds (5 minutes = 300 seconds)
  static const int otpCountdownSeconds = 300;

  /// Default Myanmar phone prefix
  static const String myanmarPhonePrefix = '+95';
}
