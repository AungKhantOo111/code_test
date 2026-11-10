import 'dart:math' as math;
import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double shakeOffset;

  const ShakeWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.shakeOffset = 12.0,
  });

  @override
  State<ShakeWidget> createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  void shake() {
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double sine = math.sin(_controller.value * math.pi * 4);
        return Transform.translate(
          offset: Offset(sine * widget.shakeOffset * (1.0 - _controller.value), 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
