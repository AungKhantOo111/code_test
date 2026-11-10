import 'package:flutter/material.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/reward_models.dart';

class TierLadderWidget extends StatefulWidget {
  final List<TierInfo> tiers;

  const TierLadderWidget({
    super.key,
    required this.tiers,
  });

  @override
  State<TierLadderWidget> createState() => _TierLadderWidgetState();
}

class _TierLadderWidgetState extends State<TierLadderWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _lineFillAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.deliberate,
    );

    _lineFillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: AppCurves.easeInOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tiers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < widget.tiers.length; i++) ...[
          _buildTierRow(widget.tiers[i], i),
          if (i < widget.tiers.length - 1)
            _buildAnimatedConnector(i),
        ],
      ],
    );
  }

  Widget _buildTierRow(TierInfo tier, int index) {
    final startInterval = (index * 0.15).clamp(0.0, 0.6);
    final endInterval = (startInterval + 0.35).clamp(0.0, 1.0);

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(startInterval, endInterval, curve: AppCurves.easeOut),
      ),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(-0.15, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(startInterval, endInterval, curve: AppCurves.easeOutCubic),
      ),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBadge(tier),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tier.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: tier.isCurrent ? FontWeight.w800 : FontWeight.w700,
                          color: tier.isCurrent ? AppColors.textPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tier.subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: tier.isCurrent ? AppColors.textSecondary : AppColors.textMuted,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge(TierInfo tier) {
    Color bgColor;
    Color iconColor;
    String letter;

    switch (tier.name.toLowerCase()) {
      case 'gold':
        bgColor = const Color(0xFFFFF7DF);
        iconColor = const Color(0xFFFFB800);
        letter = 'G';
        break;
      case 'platinum':
        bgColor = const Color(0xFFE6F8FB);
        iconColor = const Color(0xFF45C6DF);
        letter = 'P';
        break;
      case 'silver':
      default:
        bgColor = const Color(0xFFEEEEF2);
        iconColor = const Color(0xFF9E9EA7);
        letter = 'S';
        break;
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: tier.isCurrent ? iconColor : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 9, color: iconColor),
            Text(
              letter,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: iconColor,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedConnector(int index) {
    return Container(
      margin: const EdgeInsets.only(left: 13),
      width: 2,
      height: 24,
      child: AnimatedBuilder(
        animation: _lineFillAnimation,
        builder: (context, child) {
          final isSilverToGold = index == 0;
          final fillPercent = isSilverToGold ? _lineFillAnimation.value : 0.0;

          return CustomPaint(
            painter: _ConnectorLinePainter(fillPercent: fillPercent),
          );
        },
      ),
    );
  }
}

class _ConnectorLinePainter extends CustomPainter {
  final double fillPercent;

  _ConnectorLinePainter({required this.fillPercent});

  @override
  void paint(Canvas canvas, Size size) {
    // Background track (gray line)
    final bgPaint = Paint()
      ..color = const Color(0xFFE2E4E8)
      ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset.zero,
      Offset(0, size.height),
      bgPaint,
    );

    // Active progress fill (cyan/pink animated)
    if (fillPercent > 0) {
      final fillPaint = Paint()
        ..color = AppColors.accentPink
        ..strokeWidth = 2.0;

      canvas.drawLine(
        Offset.zero,
        Offset(0, size.height * fillPercent),
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ConnectorLinePainter oldDelegate) =>
      oldDelegate.fillPercent != fillPercent;
}
