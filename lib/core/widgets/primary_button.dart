import 'package:flutter/material.dart';
import '../motion/app_motion.dart';
import '../theme/app_theme.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double? width;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.height = 52.0,
    this.width,
    this.backgroundColor,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;
    final Color effectiveColor = widget.backgroundColor ?? AppColors.primary;

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: AppDurations.getDuration(context, AppDurations.quick),
        curve: AppCurves.easeOut,
        child: AnimatedContainer(
          duration: AppDurations.getDuration(context, AppDurations.standard),
          curve: AppCurves.easeInOut,
          decoration: BoxDecoration(
            color: isEnabled
                ? effectiveColor
                : (widget.isLoading
                    ? effectiveColor
                    : effectiveColor.withValues(alpha: 0.4)),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: effectiveColor.withValues(alpha: 0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : const [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
              onHighlightChanged: (highlighted) {
                if (mounted) setState(() => _isPressed = highlighted);
              },
              onTap: isEnabled ? widget.onPressed : null,
              child: Center(
                child: AnimatedSwitcher(
                  duration: AppDurations.getDuration(context, AppDurations.quick),
                  child: widget.isLoading
                      ? const SizedBox(
                          key: ValueKey('loading'),
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.label.toUpperCase(),
                          key: const ValueKey('text'),
                          style: AppTypography.button,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
