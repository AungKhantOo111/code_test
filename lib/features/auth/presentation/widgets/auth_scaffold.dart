import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'progress_ring.dart';

class AuthScaffold extends StatelessWidget {
  final int step; // 1 to 4
  final bool isCompleted;
  final String title;
  final String? subtitle;
  final Widget content;
  final Widget actionButton;
  final VoidCallback? onBack;

  const AuthScaffold({
    super.key,
    required this.step,
    this.isCompleted = false,
    required this.title,
    this.subtitle,
    required this.content,
    required this.actionButton,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    // Top navigation bar with Back button & Progress Ring
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                        ProgressRingWidget(
                          step: step,
                          isCompleted: isCompleted,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Screen Title
                    Text(
                      title,
                      style: AppTypography.titleLarge,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        subtitle!,
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),

                    // Main Form Content
                    Expanded(
                      child: content,
                    ),

                    const SizedBox(height: AppSpacing.md),
                    // Action Button
                    actionButton,
                    const SizedBox(height: AppSpacing.md),

                    // Footer disclaimer
                    Center(
                      child: GestureDetector(
                        onTap: () => _showTermsBottomSheet(context),
                        child: Text(
                          'By continuing, you acknowledge that you have read and\nagree to our Terms of Use and Privacy Policy.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            color: AppColors.textMuted,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showTermsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Terms of Use & Privacy Policy', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Welcome to J\'Donuts. By registering and utilizing our services, you accept our standard customer loyalty terms, order guidelines, and privacy policies.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('I Understand', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
