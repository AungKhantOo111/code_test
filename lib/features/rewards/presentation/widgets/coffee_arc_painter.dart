import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CoffeeArcWidget extends StatelessWidget {
  final int current; // 9
  final int target;  // 12
  final double size;

  const CoffeeArcWidget({
    super.key,
    required this.current,
    required this.target,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background & filled arc
          CustomPaint(
            size: Size(size, size),
            painter: CoffeeArcPainter(progress: progress),
          ),
          // Coffee cup image centered
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Image.asset(
              'assets/images/6.png',
              width: size * 0.55,
              height: size * 0.55,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.local_cafe_rounded,
                color: Color(0xFF8B4513),
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CoffeeArcPainter extends CustomPainter {
  final double progress;

  CoffeeArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 4);
    final radius = (size.width / 2) - 4.0;
    const strokeWidth = 5.0;

    // Arc spans from 145 degrees (bottom left) over the top to 35 degrees (bottom right)
    // 250 degrees total sweep = ~4.363 rad
    final startAngle = 145 * math.pi / 180;
    final totalSweep = 250 * math.pi / 180;

    // 1. Background arc track
    final trackPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalSweep,
      false,
      trackPaint,
    );

    // 2. Filled progress arc
    if (progress > 0) {
      final fillPaint = Paint()
        ..color = AppColors.accentOrange
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        totalSweep * progress,
        false,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CoffeeArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
