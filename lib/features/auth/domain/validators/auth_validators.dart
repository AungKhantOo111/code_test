import '../../../../core/constants/app_constants.dart';

class PhoneValidationResult {
  final bool isValid;
  final String? normalizedPhone; // e.g., +959254135592
  final String? errorMessage;

  const PhoneValidationResult({
    required this.isValid,
    this.normalizedPhone,
    this.errorMessage,
  });
}

class PhoneValidator {
  PhoneValidator._();

  /// Validates Myanmar phone number:
  /// - Strips spaces, dashes
  /// - If +95 prefix present, strips it
  /// - Strips one leading 0
  /// - Must be 9 followed by 7 to 9 digits (total 8 to 10 digits)
  /// - Returns formatted string e.g. +959254135592
  static PhoneValidationResult validate(String input) {
    var cleaned = input.replaceAll(RegExp(r'[\s\-]'), '');
    if (cleaned.isEmpty) {
      return const PhoneValidationResult(
        isValid: false,
        errorMessage: 'Phone number is required',
      );
    }

    if (cleaned.startsWith('+95')) {
      cleaned = cleaned.substring(3);
    } else if (cleaned.startsWith('95')) {
      cleaned = cleaned.substring(2);
    }

    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }

    // Must be 9 followed by 7 to 9 digits (so 8 to 10 digits total)
    final phoneRegex = RegExp(r'^9\d{7,9}$');
    if (!phoneRegex.hasMatch(cleaned)) {
      return const PhoneValidationResult(
        isValid: false,
        errorMessage: 'Enter a valid Myanmar number (e.g. 09254135592)',
      );
    }

    final normalized = '${AppConstants.myanmarPhonePrefix}$cleaned';
    return PhoneValidationResult(
      isValid: true,
      normalizedPhone: normalized,
    );
  }
}

class NameValidator {
  NameValidator._();

  // Allows Latin letters, Myanmar Unicode script (\u1000-\u109F), and whitespace
  static final RegExp _nameCharRegex = RegExp(r'^[a-zA-Z\s\u1000-\u109F]+$');
  static final RegExp _hasDigitRegex = RegExp(r'\d');

  /// First name: Required, 1 to 50 characters after trimming, letters & spaces, Myanmar script, no digits
  static String? validateFirstName(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return 'First name is required';
    }
    if (trimmed.length > 50) {
      return 'First name cannot exceed 50 characters';
    }
    if (_hasDigitRegex.hasMatch(trimmed)) {
      return 'First name cannot contain numbers';
    }
    if (!_nameCharRegex.hasMatch(trimmed)) {
      return 'First name can only contain letters and spaces';
    }
    return null;
  }

  /// Last name: Optional, same rules when provided
  static String? validateLastName(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return null; // Optional
    }
    if (trimmed.length > 50) {
      return 'Last name cannot exceed 50 characters';
    }
    if (_hasDigitRegex.hasMatch(trimmed)) {
      return 'Last name cannot contain numbers';
    }
    if (!_nameCharRegex.hasMatch(trimmed)) {
      return 'Last name can only contain letters and spaces';
    }
    return null;
  }
}

class DobValidator {
  DobValidator._();

  /// Validates calendar date and minimum age (at least 13)
  static String? validate({
    required int? day,
    required int? month,
    required int? year,
    DateTime? referenceDate,
  }) {
    if (day == null || month == null || year == null) {
      return 'Please enter a complete date of birth';
    }

    if (month < 1 || month > 12) {
      return 'Invalid month';
    }

    if (year < 1900) {
      return 'Year is too far in the past';
    }

    final birthDate = DateTime(year, month, day);
    // DateTime rolls invalid days over (31 Apr -> 1 May), so a mismatch
    // means the day does not exist in that month/year.
    if (day < 1 || birthDate.month != month || birthDate.day != day) {
      return 'Invalid day for selected month';
    }
    final now = referenceDate ?? DateTime.now();

    if (birthDate.isAfter(now)) {
      return 'Date of birth cannot be in the future';
    }

    // Calculate age
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    if (age < AppConstants.minAgeYears) {
      return 'You must be at least ${AppConstants.minAgeYears} years old to register';
    }

    return null;
  }

}

class OtpValidator {
  OtpValidator._();

  /// Validates 6-digit OTP code against the fake pass code
  static bool validate(String code) {
    if (code.length != 6) return false;
    return code == AppConstants.fakeValidOtp;
  }
}
