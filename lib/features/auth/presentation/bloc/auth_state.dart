import '../../../../core/constants/app_constants.dart';
import '../../domain/models/user.dart';
import '../../domain/validators/auth_validators.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final String? phoneErrorMessage;
  final String? otpErrorMessage;
  final String? nameErrorMessage;
  final String? dobErrorMessage;

  // Form Fields
  final String rawPhone;
  final String normalizedPhone;
  final String otp;
  final String firstName;
  final String lastName;
  final int? birthDay;
  final int? birthMonth;
  final int? birthYear;

  // Flow State
  final bool isLoginFlow;
  final int otpFailedAttempts;
  final bool isOtpLocked;
  final int otpCountdown;
  final User? currentUser;

  // One-time action triggers for UI navigation/feedback
  final bool phoneSubmittedSuccess;
  final bool otpSubmittedSuccess;
  final bool registrationSuccess;
  final bool otpFailedTrigger;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.phoneErrorMessage,
    this.otpErrorMessage,
    this.nameErrorMessage,
    this.dobErrorMessage,
    this.rawPhone = '',
    this.normalizedPhone = '',
    this.otp = '',
    this.firstName = '',
    this.lastName = '',
    this.birthDay,
    this.birthMonth,
    this.birthYear,
    this.isLoginFlow = false,
    this.otpFailedAttempts = 0,
    this.isOtpLocked = false,
    this.otpCountdown = AppConstants.otpCountdownSeconds,
    this.currentUser,
    this.phoneSubmittedSuccess = false,
    this.otpSubmittedSuccess = false,
    this.registrationSuccess = false,
    this.otpFailedTrigger = false,
  });

  bool get isPhoneValid {
    final res = PhoneValidator.validate(rawPhone);
    return res.isValid;
  }

  bool get isNameValid {
    return NameValidator.validateFirstName(firstName) == null &&
        NameValidator.validateLastName(lastName) == null;
  }

  bool get isDobValid {
    return DobValidator.validate(
          day: birthDay,
          month: birthMonth,
          year: birthYear,
        ) ==
        null;
  }

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? phoneErrorMessage,
    String? otpErrorMessage,
    String? nameErrorMessage,
    String? dobErrorMessage,
    String? rawPhone,
    String? normalizedPhone,
    String? otp,
    String? firstName,
    String? lastName,
    int? birthDay,
    int? birthMonth,
    int? birthYear,
    bool? isLoginFlow,
    int? otpFailedAttempts,
    bool? isOtpLocked,
    int? otpCountdown,
    User? currentUser,
    bool? phoneSubmittedSuccess,
    bool? otpSubmittedSuccess,
    bool? registrationSuccess,
    bool? otpFailedTrigger,
    bool clearErrors = false,
    bool clearGeneralError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrors || clearGeneralError ? null : (errorMessage ?? this.errorMessage),
      phoneErrorMessage: clearErrors ? null : (phoneErrorMessage ?? this.phoneErrorMessage),
      otpErrorMessage: clearErrors ? null : (otpErrorMessage ?? this.otpErrorMessage),
      nameErrorMessage: clearErrors ? null : (nameErrorMessage ?? this.nameErrorMessage),
      dobErrorMessage: clearErrors ? null : (dobErrorMessage ?? this.dobErrorMessage),
      rawPhone: rawPhone ?? this.rawPhone,
      normalizedPhone: normalizedPhone ?? this.normalizedPhone,
      otp: otp ?? this.otp,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDay: birthDay ?? this.birthDay,
      birthMonth: birthMonth ?? this.birthMonth,
      birthYear: birthYear ?? this.birthYear,
      isLoginFlow: isLoginFlow ?? this.isLoginFlow,
      otpFailedAttempts: otpFailedAttempts ?? this.otpFailedAttempts,
      isOtpLocked: isOtpLocked ?? this.isOtpLocked,
      otpCountdown: otpCountdown ?? this.otpCountdown,
      currentUser: currentUser ?? this.currentUser,
      phoneSubmittedSuccess: phoneSubmittedSuccess ?? false,
      otpSubmittedSuccess: otpSubmittedSuccess ?? false,
      registrationSuccess: registrationSuccess ?? false,
      otpFailedTrigger: otpFailedTrigger ?? false,
    );
  }
}
