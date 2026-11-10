import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _donutDriftAnimation;
  late final Animation<double> _titleFadeAnimation;
  late final Animation<double> _buttonFadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppDurations.slow,
    );

    _donutDriftAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.65, curve: AppCurves.easeOutCubic),
    );

    _titleFadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.35, 0.8, curve: AppCurves.easeOut),
    );

    _buttonFadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.6, 1.0, curve: AppCurves.easeOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showPlaceholder(BuildContext context, String service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$service authentication is not enabled in this code test.'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              // Floating animated circular donut illustration composition
              Expanded(
                flex: 6,
                child: AnimatedBuilder(
                  animation: _donutDriftAnimation,
                  builder: (context, child) {
                    final progress = _donutDriftAnimation.value;
                    final translateY = 25.0 * (1.0 - progress);

                    return Opacity(
                      opacity: progress,
                      child: Transform.translate(
                        offset: Offset(0, translateY),
                        child: child,
                      ),
                    );
                  },
                  child: Center(
                    child: SizedBox(
                      width: 320,
                      height: 280,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. Satellite Top Left (Donut 1)
                          Positioned(
                            left: 10,
                            top: 20,
                            child: _buildDonutCircle(
                              imagePath: 'assets/images/1.png',
                              size: 78,
                              backgroundColor: const Color(0xFFFDE8EF),
                            ),
                          ),

                          // 2. Satellite Top Right (Donut 2)
                          Positioned(
                            right: 15,
                            top: 15,
                            child: _buildDonutCircle(
                              imagePath: 'assets/images/2.png',
                              size: 74,
                              backgroundColor: const Color(0xFFF5EBFD),
                            ),
                          ),

                          // 3. Central Hero Donut Circle (Donut 3)
                          Center(
                            child: Container(
                              width: 175,
                              height: 175,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE8F6FA),
                                border: Border.all(color: Colors.white, width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.2),
                                    blurRadius: 28,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(18),
                              child: const AppCachedImage(
                                imageUrl: 'assets/images/3.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          // 4. Satellite Bottom Left (Donut 4)
                          Positioned(
                            left: 20,
                            bottom: 15,
                            child: _buildDonutCircle(
                              imagePath: 'assets/images/4.png',
                              size: 68,
                              backgroundColor: const Color(0xFFFFF0E6),
                            ),
                          ),

                          // 5. Satellite Bottom Right (Donut 5)
                          Positioned(
                            right: 20,
                            bottom: 25,
                            child: _buildDonutCircle(
                              imagePath: 'assets/images/5.png',
                              size: 82,
                              backgroundColor: const Color(0xFFE8FBF4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Title section
              FadeTransition(
                opacity: _titleFadeAnimation,
                child: Text(
                  'Round food for\nevery mood',
                  textAlign: TextAlign.center,
                  style: AppTypography.titleLarge.copyWith(fontSize: 32),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Buttons & Actions Section
              FadeTransition(
                opacity: _buttonFadeAnimation,
                child: Column(
                  children: [
                    PrimaryButton(
                      label: "LET'S GET STARTED",
                      onPressed: () {
                        context.read<AuthBloc>().add(const StartFlowEvent(isLogin: false));
                        context.push('/auth/phone');
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Log In link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: AppTypography.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<AuthBloc>().add(const StartFlowEvent(isLogin: true));
                            context.push('/auth/phone');
                          },
                          child: Text(
                            'Log in',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.accentPink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Social login buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialButton(
                          icon: Icons.g_mobiledata,
                          iconSize: 32,
                          onPressed: () => _showPlaceholder(context, 'Google'),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _SocialButton(
                          icon: Icons.apple,
                          iconSize: 24,
                          onPressed: () => _showPlaceholder(context, 'Apple'),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _SocialButton(
                          icon: Icons.facebook,
                          iconSize: 24,
                          onPressed: () => _showPlaceholder(context, 'Facebook'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Disclaimer
                    GestureDetector(
                      onTap: () {
                        _showPlaceholder(context, 'Terms & Privacy Policy');
                      },
                      child: Text(
                        'By continuing, you acknowledge that you have read and\nagree to our Terms of Use and Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonutCircle({
    required String imagePath,
    required double size,
    required Color backgroundColor,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: AppCachedImage(
        imageUrl: imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.iconSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: iconSize, color: AppColors.textPrimary),
      ),
    );
  }
}
