import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../core/widgets/app_cached_image.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.slow,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 1.0, curve: AppCurves.easeOut),
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD6EEFB),
              Color(0xFFFDF7FA),
              Color(0xFFFCE4EE),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Staggered 4 Donut Tiles Composition matching PDF Screen 7
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Column (touches left edge & top edge)
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 11,
                            child: _buildStaggeredTile(
                              index: 0,
                              backgroundColor: const Color(0xFFBCE3FA),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(28),
                              ),
                              imagePath: 'assets/images/3.png',
                              rotationAngle: -math.pi / 9,
                              alignment: const Alignment(-0.15, 0.2),
                              showConfetti: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            flex: 11,
                            child: _buildStaggeredTile(
                              index: 2,
                              backgroundColor: const Color(0xFFFCE6DE),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(28),
                                bottomRight: Radius.circular(28),
                              ),
                              imagePath: 'assets/images/2.png',
                              rotationAngle: -math.pi / 10,
                              alignment: Alignment.center,
                              showConfetti: true,
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Right Column (offset downward, touches right edge)
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 54),
                          Expanded(
                            flex: 11,
                            child: _buildStaggeredTile(
                              index: 1,
                              backgroundColor: const Color(0xFFFADAE8),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(28),
                                bottomLeft: Radius.circular(28),
                              ),
                              imagePath: 'assets/images/5.png',
                              rotationAngle: math.pi / 12,
                              alignment: const Alignment(0.35, 0.0),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            flex: 10,
                            child: _buildStaggeredTile(
                              index: 3,
                              backgroundColor: const Color(0xFFF8B619),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(28),
                                bottomLeft: Radius.circular(28),
                              ),
                              imagePath: 'assets/images/1.png',
                              rotationAngle: -math.pi / 10,
                              alignment: const Alignment(0.35, 0.15),
                              showGoldenWaves: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Title and Action Button Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const Text(
                        "Welcome to the\nworld of J'donuts",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F1F29),
                          height: 1.22,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF56C6E6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () => context.go('/home'),
                          child: const Text(
                            "LET'S EXPLORE",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaggeredTile({
    required int index,
    required Color backgroundColor,
    required BorderRadius borderRadius,
    required String imagePath,
    required double rotationAngle,
    required Alignment alignment,
    bool showConfetti = false,
    bool showGoldenWaves = false,
  }) {
    final startInterval = (index * 0.12).clamp(0.0, 0.6);
    final endInterval = (startInterval + 0.4).clamp(0.0, 1.0);

    final tileSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            Interval(startInterval, endInterval, curve: AppCurves.easeOutCubic),
      ),
    );

    final tileFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(startInterval, endInterval, curve: AppCurves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: tileFade,
          child: SlideTransition(
            position: tileSlide,
            child: child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (showConfetti)
                CustomPaint(
                  painter: _ConfettiLinesPainter(
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                ),
              if (showGoldenWaves)
                Positioned(
                  left: -20,
                  top: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                        width: 18,
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: alignment,
                child: Transform.rotate(
                  angle: rotationAngle,
                  child: SizedBox(
                    width: 145,
                    height: 145,
                    child: AppCachedImage(
                      imageUrl: imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfettiLinesPainter extends CustomPainter {
  final Color color;

  const _ConfettiLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.18, size.height * 0.2),
      Offset(size.width * 0.26, size.height * 0.14),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.75, size.height * 0.25),
      Offset(size.width * 0.82, size.height * 0.33),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.8),
      Offset(size.width * 0.3, size.height * 0.86),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.72, size.height * 0.78),
      Offset(size.width * 0.66, size.height * 0.86),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
