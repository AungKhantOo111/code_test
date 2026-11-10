import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/validators/auth_validators.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  Timer? _countdownTimer;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState()) {
    on<CheckInitialSessionEvent>(_onCheckInitialSession);
    on<StartFlowEvent>(_onStartFlow);
    on<PhoneChangedEvent>(_onPhoneChanged);
    on<PhoneBlurredEvent>(_onPhoneBlurred);
    on<SubmitPhoneEvent>(_onSubmitPhone);
    on<OtpChangedEvent>(_onOtpChanged);
    on<SubmitOtpEvent>(_onSubmitOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<OtpTickEvent>(_onOtpTick);
    on<NameChangedEvent>(_onNameChanged);
    on<ValidateNameEvent>(_onValidateName);
    on<DobChangedEvent>(_onDobChanged);
    on<SubmitRegistrationEvent>(_onSubmitRegistration);
    on<LogoutEvent>(_onLogout);

    add(const CheckInitialSessionEvent());
  }

  Future<void> _onCheckInitialSession(
    CheckInitialSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    final session = await _authRepository.getCurrentSession();
    if (session != null) {
      emit(state.copyWith(currentUser: session));
    }
  }

  void _onStartFlow(
    StartFlowEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      isLoginFlow: event.isLogin,
      clearErrors: true,
      otpFailedAttempts: 0,
      isOtpLocked: false,
    ));
  }

  void _onPhoneChanged(
    PhoneChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      rawPhone: event.phone,
      phoneErrorMessage: null,
    ));
  }

  void _onPhoneBlurred(
    PhoneBlurredEvent event,
    Emitter<AuthState> emit,
  ) {
    final result = PhoneValidator.validate(state.rawPhone);
    if (!result.isValid) {
      emit(state.copyWith(phoneErrorMessage: result.errorMessage));
    } else {
      emit(state.copyWith(
        normalizedPhone: result.normalizedPhone,
        phoneErrorMessage: null,
      ));
    }
  }

  Future<void> _onSubmitPhone(
    SubmitPhoneEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.isLoading) return;

    final res = PhoneValidator.validate(state.rawPhone);
    if (!res.isValid) {
      emit(state.copyWith(phoneErrorMessage: res.errorMessage));
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      normalizedPhone: res.normalizedPhone,
      clearGeneralError: true,
    ));

    try {
      final isRegisteredResult =
          await _authRepository.isPhoneRegistered(res.normalizedPhone!);
      final isRegistered = isRegisteredResult.dataOrNull ?? false;

      if (state.isLoginFlow && !isRegistered) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage:
              'This number has never registered. Tap below to create an account.',
        ));
        return;
      }

      await _authRepository.sendOtp(res.normalizedPhone!);
      _startOtpTimer();

      emit(state.copyWith(
        isLoading: false,
        clearErrors: true,
        phoneSubmittedSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      ));
    }
  }

  void _startOtpTimer() {
    _countdownTimer?.cancel();
    add(const OtpTickEvent(AppConstants.otpCountdownSeconds));

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.otpCountdown > 0) {
        add(OtpTickEvent(state.otpCountdown - 1));
      } else {
        timer.cancel();
      }
    });
  }

  void _onOtpTick(
    OtpTickEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      otpCountdown: event.secondsRemaining,
      isOtpLocked: event.secondsRemaining == 0 ? false : state.isOtpLocked,
    ));
  }

  void _onResendOtp(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) {
    if (state.otpCountdown > 0 && !state.isOtpLocked) return;
    _authRepository.sendOtp(state.normalizedPhone);
    _startOtpTimer();
    emit(state.copyWith(
      otpErrorMessage: null,
      otp: '',
      isOtpLocked: false,
      otpFailedAttempts: 0,
    ));
  }

  void _onOtpChanged(
    OtpChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(otp: event.otp, otpErrorMessage: null));
  }

  Future<void> _onSubmitOtp(
    SubmitOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.isLoading || state.isOtpLocked) return;

    emit(state.copyWith(isLoading: true, otp: event.code, otpErrorMessage: null));

    final isValid = OtpValidator.validate(event.code);
    if (!isValid) {
      final newFailCount = state.otpFailedAttempts + 1;
      final locked = newFailCount >= AppConstants.maxOtpAttempts;

      emit(state.copyWith(
        isLoading: false,
        otpFailedAttempts: newFailCount,
        isOtpLocked: locked,
        otpFailedTrigger: true,
        otpErrorMessage: locked
            ? 'Too many incorrect attempts. Entry is locked until you resend.'
            : 'Invalid OTP code. Passcode is 123456.',
      ));
      return;
    }

    _countdownTimer?.cancel();

    if (state.isLoginFlow) {
      final loginResult = await _authRepository.loginWithOtp(
        normalizedPhone: state.normalizedPhone,
        otp: event.code,
      );

      loginResult.fold(
        onSuccess: (user) {
          emit(state.copyWith(
            isLoading: false,
            currentUser: user,
            otpSubmittedSuccess: true,
          ));
        },
        onFailure: (failure) {
          emit(state.copyWith(
            isLoading: false,
            otpErrorMessage: failure.message,
            otpFailedTrigger: true,
          ));
        },
      );
    } else {
      emit(state.copyWith(
        isLoading: false,
        clearErrors: true,
        otpSubmittedSuccess: true,
      ));
    }
  }

  void _onNameChanged(
    NameChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      firstName: event.firstName,
      lastName: event.lastName,
      nameErrorMessage: null,
    ));
  }

  void _onValidateName(
    ValidateNameEvent event,
    Emitter<AuthState> emit,
  ) {
    final firstErr = NameValidator.validateFirstName(state.firstName);
    if (firstErr != null) {
      emit(state.copyWith(nameErrorMessage: firstErr));
      return;
    }
    final lastErr = NameValidator.validateLastName(state.lastName);
    if (lastErr != null) {
      emit(state.copyWith(nameErrorMessage: lastErr));
      return;
    }
    emit(state.copyWith(nameErrorMessage: null));
  }

  void _onDobChanged(
    DobChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      birthDay: event.day ?? state.birthDay,
      birthMonth: event.month ?? state.birthMonth,
      birthYear: event.year ?? state.birthYear,
      dobErrorMessage: null,
    ));
  }

  Future<void> _onSubmitRegistration(
    SubmitRegistrationEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state.isLoading) return;

    final dobErr = DobValidator.validate(
      day: state.birthDay,
      month: state.birthMonth,
      year: state.birthYear,
    );
    if (dobErr != null) {
      emit(state.copyWith(dobErrorMessage: dobErr));
      return;
    }

    emit(state.copyWith(isLoading: true, clearGeneralError: true));

    final dob = DateTime(state.birthYear!, state.birthMonth!, state.birthDay!);
    final regResult = await _authRepository.register(
      normalizedPhone: state.normalizedPhone,
      firstName: state.firstName.trim(),
      lastName: state.lastName.trim().isEmpty ? null : state.lastName.trim(),
      dateOfBirth: dob,
    );

    regResult.fold(
      onSuccess: (user) {
        emit(state.copyWith(
          isLoading: false,
          currentUser: user,
          registrationSuccess: true,
        ));
      },
      onFailure: (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    _countdownTimer?.cancel();
    emit(const AuthState());
    await _authRepository.logout();
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
