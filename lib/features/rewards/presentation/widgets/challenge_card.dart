import 'package:flutter/material.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/reward_models.dart';
import 'coffee_arc_painter.dart';
import 'donut_progress_painter.dart';

class ChallengeCard extends StatefulWidget {
  final ChallengeItem challenge;
  final int index;
  final AnimationController animationController;
  final VoidCallback onEarnPressed;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.index,
    required this.animationController,
    required this.onEarnPressed,
  });

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.challenge.isComplete) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final startInterval = (0.2 + (widget.index * 0.15)).clamp(0.0, 0.7);
    final endInterval = (startInterval + 0.35).clamp(0.0, 1.0);

    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(startInterval, endInterval, curve: AppCurves.easeOut),
      ),
    );

    final slideAnim = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(startInterval, endInterval, curve: AppCurves.easeOutCubic),
      ),
    );

    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnim,
          child: SlideTransition(
            position: slideAnim,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Progress Artwork
                  _buildArtwork(),
                  const SizedBox(width: 16),

                  // Challenge info & Earn button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.challenge.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.challenge.progressText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildEarnButton(),
                            const SizedBox(width: 14),
                            Text(
                              '${widget.challenge.rewardPoints} pts',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildArtwork() {
    if (widget.challenge.type == 'coffee') {
      return CoffeeArcWidget(
        current: widget.challenge.current,
        target: widget.challenge.target,
        size: 80,
      );
    }

    return DonutProgressWidget(
      current: widget.challenge.current,
      target: widget.challenge.target,
      size: 80,
    );
  }

  Widget _buildEarnButton() {
    final isComplete = widget.challenge.isComplete;

    Widget buttonContent = AnimatedScale(
      scale: _isPressed ? 0.94 : 1.0,
      duration: AppDurations.getDuration(context, AppDurations.quick),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isComplete ? AppColors.primary : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
          boxShadow: isComplete
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          'EARN',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: isComplete ? Colors.white : const Color(0xFFA0A6B2),
          ),
        ),
      ),
    );

    // If complete, wrap in pulsing attention cue
    if (isComplete) {
      buttonContent = AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: child,
          );
        },
        child: buttonContent,
      );
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onEarnPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: buttonContent,
    );
  }
}
