sealed class AuthEvent {
  const AuthEvent();
}

class CheckInitialSessionEvent extends AuthEvent {
  const CheckInitialSessionEvent();
}

class StartFlowEvent extends AuthEvent {
  final bool isLogin;
  const StartFlowEvent({required this.isLogin});
}

class PhoneChangedEvent extends AuthEvent {
  final String phone;
  const PhoneChangedEvent(this.phone);
}

class PhoneBlurredEvent extends AuthEvent {
  const PhoneBlurredEvent();
}

class SubmitPhoneEvent extends AuthEvent {
  const SubmitPhoneEvent();
}

class OtpChangedEvent extends AuthEvent {
  final String otp;
  const OtpChangedEvent(this.otp);
}

class SubmitOtpEvent extends AuthEvent {
  final String code;
  const SubmitOtpEvent(this.code);
}

class ResendOtpEvent extends AuthEvent {
  const ResendOtpEvent();
}

class OtpTickEvent extends AuthEvent {
  final int secondsRemaining;
  const OtpTickEvent(this.secondsRemaining);
}

class NameChangedEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  const NameChangedEvent({required this.firstName, required this.lastName});
}

class ValidateNameEvent extends AuthEvent {
  const ValidateNameEvent();
}

class DobChangedEvent extends AuthEvent {
  final int? day;
  final int? month;
  final int? year;
  const DobChangedEvent({this.day, this.month, this.year});
}

class SubmitRegistrationEvent extends AuthEvent {
  const SubmitRegistrationEvent();
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}
