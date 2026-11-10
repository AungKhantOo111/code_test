import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../core/theme/app_theme.dart';

class PointsRingWidget extends StatefulWidget {
  final int totalPoints;
  final double targetProgress; // e.g. 0.75

  const PointsRingWidget({
    super.key,
    required this.totalPoints,
    this.targetProgress = 0.72,
  });

  @override
  State<PointsRingWidget> createState() => _PointsRingWidgetState();
}

class _PointsRingWidgetState extends State<PointsRingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sweepAnimation;
  late final Animation<double> _countAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.counter,
    );

    _sweepAnimation = Tween<double>(begin: 0.0, end: widget.targetProgress).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppCurves.easeOutCubic,
      ),
    );

    _countAnimation = Tween<double>(begin: 0.0, end: widget.totalPoints.toDouble()).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppCurves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    final str = number.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write(',');
      }
    }
    return buffer.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final currentPoints = _countAnimation.value.toInt();

        return SizedBox(
          width: 175,
          height: 175,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(175, 175),
                painter: _DonutRingPainter(
                  progress: _sweepAnimation.value,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total points',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatNumber(currentPoints),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentPink,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DonutRingPainter extends CustomPainter {
  final double progress;

  _DonutRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    const strokeWidth = 32.0;
    final ringRadius = outerRadius - (strokeWidth / 2);

    // 1. Draw light background track
    final trackPaint = Paint()
      ..color = const Color(0xFFF0F1F4)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, ringRadius, trackPaint);

    if (progress <= 0) return;

    // 2. Draw sweeping frosted pink donut arc
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    final arcPaint = Paint()
      ..color = AppColors.accentPink
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: ringRadius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // 3. Draw sprinkle dashes along the animated frosted arc
    final sprinklePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final sprinkleCount = (progress * 18).toInt();
    for (int i = 1; i <= sprinkleCount; i++) {
      final angle = startAngle + (sweepAngle * (i / (sprinkleCount + 1)));
      final sprinkleCenter = Offset(
        center.dx + ringRadius * math.cos(angle),
        center.dy + ringRadius * math.sin(angle),
      );

      final sprinkleAngle = angle + (i % 2 == 0 ? 0.6 : -0.6);
      const sprinkleLength = 4.5;
      final p1 = Offset(
        sprinkleCenter.dx - sprinkleLength * math.cos(sprinkleAngle),
        sprinkleCenter.dy - sprinkleLength * math.sin(sprinkleAngle),
      );
      final p2 = Offset(
        sprinkleCenter.dx + sprinkleLength * math.cos(sprinkleAngle),
        sprinkleCenter.dy + sprinkleLength * math.sin(sprinkleAngle),
      );

      canvas.drawLine(p1, p2, sprinklePaint);
    }
  }

  @override
  bool shouldRepaint(_DonutRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
