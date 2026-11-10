import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_scaffold.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  late final TextEditingController _phoneController;
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final currentRaw = context.read<AuthBloc>().state.rawPhone;
    _phoneController = TextEditingController(text: currentRaw);

    _phoneFocusNode.addListener(() {
      if (!_phoneFocusNode.hasFocus) {
        context.read<AuthBloc>().add(const PhoneBlurredEvent());
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => curr.phoneSubmittedSuccess && !prev.phoneSubmittedSuccess,
      listener: (context, state) {
        context.push('/auth/otp');
      },
      builder: (context, state) {
        final authBloc = context.read<AuthBloc>();

        return AuthScaffold(
          step: 1,
          title: 'Enter your phone\nnumber',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phone Input Box with +95 Prefix
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
                  border: Border.all(
                    color: state.phoneErrorMessage != null
                        ? AppColors.error
                        : (_phoneFocusNode.hasFocus ? AppColors.borderFocused : AppColors.border),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // +95 Prefix Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: const Text(
                        AppConstants.myanmarPhonePrefix,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    // Phone Input Field
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        focusNode: _phoneFocusNode,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-]')),
                        ],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                        decoration: const InputDecoration(
                          hintText: '09254135592',
                          hintStyle: TextStyle(color: AppColors.textMuted),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.md,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (val) => authBloc.add(PhoneChangedEvent(val)),
                      ),
                    ),
                  ],
                ),
              ),

              // Inline Error Message if any
              if (state.phoneErrorMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  state.phoneErrorMessage!,
                  style: AppTypography.error,
                ),
              ],

              // Registration prompt if un-registered phone in login flow
              if (state.errorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.errorMessage!,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      GestureDetector(
                        onTap: () {
                          authBloc.add(const StartFlowEvent(isLogin: false));
                        },
                        child: Text(
                          'Tap here to create a new account',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.accentPink,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actionButton: PrimaryButton(
            label: 'CONTINUE',
            isLoading: state.isLoading,
            onPressed: state.isPhoneValid
                ? () {
                    FocusScope.of(context).unfocus();
                    authBloc.add(const SubmitPhoneEvent());
                  }
                : null,
          ),
        );
      },
    );
  }
}
