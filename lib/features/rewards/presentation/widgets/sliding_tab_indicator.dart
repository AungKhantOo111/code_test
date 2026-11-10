import 'package:flutter/material.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../core/theme/app_theme.dart';

class SlidingTabIndicator extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const SlidingTabIndicator({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F4),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              // Sliding Active Pill
              AnimatedPositioned(
                duration: AppDurations.getDuration(context, AppDurations.standard),
                curve: AppCurves.easeInOut,
                left: selectedIndex * tabWidth,
                top: 3,
                bottom: 3,
                width: tabWidth,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              // Tab Titles
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
                      onTap: () => onTabSelected(0),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: AppDurations.getDuration(context, AppDurations.quick),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: selectedIndex == 0 ? FontWeight.w700 : FontWeight.w600,
                            color: selectedIndex == 0 ? Colors.white : AppColors.textSecondary,
                          ),
                          child: const Text('Eat more earn more'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
                      onTap: () => onTabSelected(1),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: AppDurations.getDuration(context, AppDurations.quick),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: selectedIndex == 1 ? FontWeight.w700 : FontWeight.w600,
                            color: selectedIndex == 1 ? Colors.white : AppColors.textSecondary,
                          ),
                          child: const Text('Gift'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
