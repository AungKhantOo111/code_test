import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_scaffold.dart';

class DobScreen extends StatelessWidget {
  const DobScreen({super.key});

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  void _showBirthdayBottomSheet(BuildContext context, AuthState state) {
    final now = DateTime.now();
    int tempDay = state.birthDay ?? now.day;
    int tempMonth = state.birthMonth ?? now.month;
    int tempYear = state.birthYear ?? (now.year - 18); // Default ~18 years ago

    final currentYear = now.year;
    const startYear = 1920;
    final totalYears = currentYear - startYear + 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            // Calculate max days for the currently selected month and year
            final maxDays = DateTime(tempYear, tempMonth + 1, 0).day;
            if (tempDay > maxDays) {
              tempDay = maxDays;
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header: "Select your Birthday" and close "X"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select your Birthday',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentPink,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.textPrimary),
                          onPressed: () => Navigator.of(bottomSheetContext).pop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 3-Wheel Cupertino Date Picker (Day | Month | Year)
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          // Highlight bar across the 3 wheels
                          Center(
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F3F5).withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              // Column 1: Day
                              Expanded(
                                flex: 2,
                                child: CupertinoPicker.builder(
                                  itemExtent: 44,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: (tempDay - 1).clamp(0, maxDays - 1),
                                  ),
                                  selectionOverlay: const SizedBox.shrink(),
                                  childCount: maxDays,
                                  onSelectedItemChanged: (index) {
                                    setSheetState(() => tempDay = index + 1);
                                  },
                                  itemBuilder: (context, index) {
                                    final dayVal = index + 1;
                                    final isSelected = dayVal == tempDay;
                                    return Center(
                                      child: Text(
                                        '$dayVal',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                          color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Column 2: Month
                              Expanded(
                                flex: 4,
                                child: CupertinoPicker.builder(
                                  itemExtent: 44,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: (tempMonth - 1).clamp(0, 11),
                                  ),
                                  selectionOverlay: const SizedBox.shrink(),
                                  childCount: 12,
                                  onSelectedItemChanged: (index) {
                                    setSheetState(() => tempMonth = index + 1);
                                  },
                                  itemBuilder: (context, index) {
                                    final isSelected = (index + 1) == tempMonth;
                                    return Center(
                                      child: Text(
                                        _months[index],
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                          color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Column 3: Year
                              Expanded(
                                flex: 3,
                                child: CupertinoPicker.builder(
                                  itemExtent: 44,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: (tempYear - startYear).clamp(0, totalYears - 1),
                                  ),
                                  selectionOverlay: const SizedBox.shrink(),
                                  childCount: totalYears,
                                  onSelectedItemChanged: (index) {
                                    setSheetState(() => tempYear = startYear + index);
                                  },
                                  itemBuilder: (context, index) {
                                    final yearVal = startYear + index;
                                    final isSelected = yearVal == tempYear;
                                    return Center(
                                      child: Text(
                                        '$yearVal',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                          color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // "SELECT" Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          context.read<AuthBloc>().add(DobChangedEvent(
                                day: tempDay,
                                month: tempMonth,
                                year: tempYear,
                              ));
                          Navigator.of(bottomSheetContext).pop();
                        },
                        child: const Text(
                          'SELECT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDateFieldCard({
    required BuildContext context,
    required String value,
    required bool isPlaceholder,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          value,
          style: AppTypography.bodyLarge.copyWith(
            color: isPlaceholder ? AppColors.textMuted : AppColors.textPrimary,
            fontWeight: isPlaceholder ? FontWeight.w400 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => curr.registrationSuccess && !prev.registrationSuccess,
      listener: (context, state) {
        context.go('/welcome');
      },
      builder: (context, state) {
        final authBloc = context.read<AuthBloc>();

        final dayStr = state.birthDay?.toString() ?? 'Day';
        final isDayEmpty = state.birthDay == null;

        final monthStr = state.birthMonth != null ? _months[state.birthMonth! - 1] : 'Month';
        final isMonthEmpty = state.birthMonth == null;

        final yearStr = state.birthYear?.toString() ?? 'Year';
        final isYearEmpty = state.birthYear == null;

        return Stack(
          children: [
            AuthScaffold(
              step: 4,
              isCompleted: state.isDobValid,
              title: "What's your\ndate of birth?",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day Field Box
                  _buildDateFieldCard(
                    context: context,
                    value: dayStr,
                    isPlaceholder: isDayEmpty,
                    onTap: () => _showBirthdayBottomSheet(context, state),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Month Field Box
                  _buildDateFieldCard(
                    context: context,
                    value: monthStr,
                    isPlaceholder: isMonthEmpty,
                    onTap: () => _showBirthdayBottomSheet(context, state),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Year Field Box
                  _buildDateFieldCard(
                    context: context,
                    value: yearStr,
                    isPlaceholder: isYearEmpty,
                    onTap: () => _showBirthdayBottomSheet(context, state),
                  ),

                  // Inline Error Message if invalid (e.g. age < 13 or invalid day)
                  if (state.dobErrorMessage != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      state.dobErrorMessage!,
                      style: AppTypography.error,
                    ),
                  ],
                ],
              ),
              actionButton: PrimaryButton(
                label: 'CONTINUE',
                isLoading: state.isLoading,
                backgroundColor: state.isDobValid ? AppColors.accentPink : null,
                onPressed: state.isDobValid
                    ? () {
                        FocusScope.of(context).unfocus();
                        authBloc.add(const SubmitRegistrationEvent());
                      }
                    : null,
              ),
            ),

            // Loading overlay with "Creating..." popup as seen in the reference video
            if (state.isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.25),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Creating...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
