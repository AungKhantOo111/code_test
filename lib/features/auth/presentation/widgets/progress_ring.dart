import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../core/theme/app_theme.dart';

class ProgressRingWidget extends StatelessWidget {
  final int step; // 1 to 4
  final bool isCompleted;

  const ProgressRingWidget({
    super.key,
    required this.step,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final double targetProgress = isCompleted ? 1.0 : (step / 4.0);

    return SizedBox(
      width: 32,
      height: 32,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: targetProgress),
        duration: AppDurations.getDuration(context, AppDurations.medium),
        curve: AppCurves.easeInOut,
        builder: (context, progress, child) {
          if (progress >= 0.99 && isCompleted) {
            return AnimatedScale(
              duration: AppDurations.getDuration(context, AppDurations.quick),
              scale: 1.0,
              curve: AppCurves.elasticOut,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.accentPink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            );
          }

          return CustomPaint(
            painter: _ProgressRingPainter(
              progress: progress,
              trackColor: AppColors.surfaceVariant,
              progressColor: AppColors.accentPink,
              strokeWidth: 3.5,
            ),
          );
        },
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
