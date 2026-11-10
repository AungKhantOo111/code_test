import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/shake_widget.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _otpLength = 6;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  final GlobalKey<ShakeWidgetState> _shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentOtp => _controllers.map((c) => c.text).join();

  void _clearOtpBoxes() {
    for (var c in _controllers) {
      c.clear();
    }
    if (_focusNodes.isNotEmpty) {
      _focusNodes.first.requestFocus();
    }
  }

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < _otpLength; i++) {
        if (i < digits.length) {
          _controllers[i].text = digits[i];
        }
      }
      final nextIndex = digits.length < _otpLength ? digits.length : _otpLength - 1;
      _focusNodes[nextIndex].requestFocus();
      _checkAutoSubmit();
      return;
    }

    if (value.isNotEmpty) {
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    _checkAutoSubmit();
  }

  void _checkAutoSubmit() {
    final code = _currentOtp;
    context.read<AuthBloc>().add(OtpChangedEvent(code));
    if (code.length == _otpLength) {
      _submitOtp(code);
    }
  }

  void _submitOtp(String code) {
    context.read<AuthBloc>().add(SubmitOtpEvent(code));
  }

  String _formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remaining.toString().padLeft(2, '0')} min';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          (curr.otpSubmittedSuccess && !prev.otpSubmittedSuccess) ||
          (curr.otpFailedTrigger && !prev.otpFailedTrigger),
      listener: (context, state) {
        if (state.otpSubmittedSuccess) {
          if (state.isLoginFlow) {
            context.go('/home');
          } else {
            context.push('/auth/name');
          }
        } else if (state.otpFailedTrigger) {
          _shakeKey.currentState?.shake();
          _clearOtpBoxes();
        }
      },
      builder: (context, state) {
        final authBloc = context.read<AuthBloc>();

        return AuthScaffold(
          step: 2,
          title: 'Verify your number',
          subtitle:
              "We've sent 6 digit OTP to ${state.normalizedPhone.isNotEmpty ? state.normalizedPhone : '+959254135592'}",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.md),
              // Shaking 6 OTP boxes
              ShakeWidget(
                key: _shakeKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_otpLength, (index) {
                    return SizedBox(
                      width: 46,
                      height: 54,
                      child: KeyboardListener(
                        focusNode: FocusNode(),
                        onKeyEvent: (event) {
                          if (event is KeyDownEvent &&
                              event.logicalKey == LogicalKeyboardKey.backspace &&
                              _controllers[index].text.isEmpty &&
                              index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          enabled: !state.isOtpLocked && !state.isLoading,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          autofillHints: const [AutofillHints.oneTimeCode],
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                              borderSide: const BorderSide(
                                  color: AppColors.borderFocused, width: 2),
                            ),
                          ),
                          onChanged: (val) => _onDigitChanged(index, val),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Error message under OTP boxes
              if (state.otpErrorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  state.otpErrorMessage!,
                  textAlign: TextAlign.center,
                  style: AppTypography.error,
                ),
              ],

              const SizedBox(height: AppSpacing.xl),

              // Resend Countdown Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style:
                        AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  if (state.otpCountdown > 0 && !state.isOtpLocked)
                    Text(
                      'resend in ${_formatTimer(state.otpCountdown)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.accentPink,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        authBloc.add(const ResendOtpEvent());
                        _clearOtpBoxes();
                      },
                      child: Text(
                        'Resend now',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          actionButton: PrimaryButton(
            label: 'CONTINUE',
            isLoading: state.isLoading,
            onPressed: _currentOtp.length == _otpLength && !state.isOtpLocked
                ? () => _submitOtp(_currentOtp)
                : null,
          ),
        );
      },
    );
  }
}
