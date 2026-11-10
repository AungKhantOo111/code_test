import 'package:flutter/material.dart';

class AppDurations {
  AppDurations._();

  static const Duration quick = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 450);
  static const Duration deliberate = Duration(milliseconds: 600);
  static const Duration slow = Duration(milliseconds: 800);
  static const Duration counter = Duration(milliseconds: 1200);

  /// Helper to respect accessibility reduced motion preference
  static Duration getDuration(BuildContext context, Duration original) {
    if (MediaQuery.of(context).disableAnimations) {
      return Duration.zero;
    }
    return original;
  }
}

class AppCurves {
  AppCurves._();

  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
}
