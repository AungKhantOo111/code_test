import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DonutProgressWidget extends StatelessWidget {
  final int current;
  final int target;
  final double size;

  const DonutProgressWidget({
    super.key,
    required this.current,
    required this.target,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: DonutProgressPainter(
          completedQuarters: current.clamp(0, target),
          totalQuarters: target,
        ),
      ),
    );
  }
}

class DonutProgressPainter extends CustomPainter {
  final int completedQuarters;
  final int totalQuarters;

  DonutProgressPainter({
    required this.completedQuarters,
    required this.totalQuarters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final strokeWidth = outerRadius * 0.58;
    final ringRadius = outerRadius - (strokeWidth / 2);
    final rect = Rect.fromCircle(center: center, radius: ringRadius);

    // Quarter angles: 4 quarters starting from top (-pi/2)
    const quarterSweep = math.pi / 2;
    const gap = 0.04; // small visual slit between quarters

    for (int i = 0; i < 4; i++) {
      final startAngle = -math.pi / 2 + (i * quarterSweep) + (gap / 2);
      final sweepAngle = quarterSweep - gap;
      final isFilled = i < completedQuarters;

      final paint = Paint()
        ..color = isFilled ? AppColors.accentPink : const Color(0xFFE5E7EB)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

      // If filled with frosting, draw sprinkles
      if (isFilled) {
        final sprinklePaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round;

        final midAngle = startAngle + (sweepAngle / 2);
        for (double offset in [-0.2, 0.0, 0.2]) {
          final ang = midAngle + offset;
          final spCenter = Offset(
            center.dx + ringRadius * math.cos(ang),
            center.dy + ringRadius * math.sin(ang),
          );
          final p1 = Offset(spCenter.dx - 2.5, spCenter.dy - 2.5);
          final p2 = Offset(spCenter.dx + 2.5, spCenter.dy + 2.5);
          canvas.drawLine(p1, p2, sprinklePaint);
        }
      }
    }

    // Inner hole accent ring
    final innerHolePaint = Paint()
      ..color = const Color(0xFFD1D5DB).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, outerRadius - strokeWidth, innerHolePaint);
  }

  @override
  bool shouldRepaint(DonutProgressPainter oldDelegate) =>
      oldDelegate.completedQuarters != completedQuarters;
}
