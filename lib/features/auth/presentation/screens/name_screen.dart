import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_scaffold.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  late final TextEditingController _firstController;
  late final TextEditingController _lastController;
  final FocusNode _firstFocus = FocusNode();
  final FocusNode _lastFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    _firstController = TextEditingController(text: state.firstName);
    _lastController = TextEditingController(text: state.lastName);

    _firstFocus.addListener(() {
      if (!_firstFocus.hasFocus) {
        context.read<AuthBloc>().add(const ValidateNameEvent());
      }
    });

    _lastFocus.addListener(() {
      if (!_lastFocus.hasFocus) {
        context.read<AuthBloc>().add(const ValidateNameEvent());
      }
    });
  }

  @override
  void dispose() {
    _firstController.dispose();
    _lastController.dispose();
    _firstFocus.dispose();
    _lastFocus.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    context.read<AuthBloc>().add(NameChangedEvent(
          firstName: _firstController.text,
          lastName: _lastController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final authBloc = context.read<AuthBloc>();

        return AuthScaffold(
          step: 3,
          title: "What's your\nname?",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Name Input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
                  border: Border.all(
                    color: state.nameErrorMessage != null
                        ? AppColors.error
                        : (_firstFocus.hasFocus ? AppColors.borderFocused : AppColors.border),
                  ),
                ),
                child: TextField(
                  controller: _firstController,
                  focusNode: _firstFocus,
                  textCapitalization: TextCapitalization.words,
                  style: AppTypography.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'First Name',
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (_) => _onFieldChanged(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Last Name Input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
                  border: Border.all(
                    color: _lastFocus.hasFocus ? AppColors.borderFocused : AppColors.border,
                  ),
                ),
                child: TextField(
                  controller: _lastController,
                  focusNode: _lastFocus,
                  textCapitalization: TextCapitalization.words,
                  style: AppTypography.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'Last Name (Optional)',
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (_) => _onFieldChanged(),
                ),
              ),

              // Inline Error
              if (state.nameErrorMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  state.nameErrorMessage!,
                  style: AppTypography.error,
                ),
              ],
            ],
          ),
          actionButton: PrimaryButton(
            label: 'CONTINUE',
            isLoading: state.isLoading,
            onPressed: state.isNameValid && _firstController.text.trim().isNotEmpty
                ? () {
                    FocusScope.of(context).unfocus();
                    authBloc.add(const ValidateNameEvent());
                    if (state.isNameValid) {
                      context.push('/auth/dob');
                    }
                  }
                : null,
          ),
        );
      },
    );
  }
}
