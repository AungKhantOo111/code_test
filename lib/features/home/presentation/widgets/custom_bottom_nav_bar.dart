import 'package:flutter/material.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../core/theme/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  static const List<({IconData icon, String label})> _navItems = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.card_giftcard_rounded, label: 'Reward'),
    (icon: Icons.explore_outlined, label: 'Explore'),
    (icon: Icons.credit_card_outlined, label: 'Wallet'),
    (icon: Icons.settings_outlined, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / _navItems.length;

          return Stack(
            children: [
              // Sliding Active Pill indicator
              AnimatedPositioned(
                duration: AppDurations.getDuration(context, AppDurations.standard),
                curve: AppCurves.easeInOut,
                left: selectedIndex * itemWidth,
                top: 0,
                bottom: 0,
                width: itemWidth,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentPink,
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
              ),

              // Nav items Row
              Row(
                children: List.generate(_navItems.length, (index) {
                  final item = _navItems[index];
                  final isSelected = selectedIndex == index;

                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(26),
                      onTap: () => onItemSelected(index),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: AppDurations.getDuration(context, AppDurations.quick),
                          child: isSelected
                              ? Row(
                                  key: ValueKey('selected_$index'),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      item.icon,
                                      color: Colors.white,
                                      size: 19,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        item.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Icon(
                                  key: ValueKey('unselected_$index'),
                                  item.icon,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  size: 24,
                                ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
