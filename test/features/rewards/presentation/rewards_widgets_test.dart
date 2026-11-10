import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:code_test/features/rewards/domain/models/reward_models.dart';
import 'package:code_test/features/rewards/presentation/widgets/coffee_arc_painter.dart';
import 'package:code_test/features/rewards/presentation/widgets/donut_progress_painter.dart';
import 'package:code_test/features/rewards/presentation/widgets/points_ring_widget.dart';
import 'package:code_test/features/rewards/presentation/widgets/sliding_tab_indicator.dart';
import 'package:code_test/features/rewards/presentation/widgets/tier_ladder_widget.dart';

void main() {
  group('Rewards custom widgets tests', () {
    testWidgets('DonutProgressWidget renders correctly for quarter and full', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                DonutProgressWidget(current: 1, target: 4),
                DonutProgressWidget(current: 4, target: 4),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(DonutProgressWidget), findsNWidgets(2));
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('CoffeeArcWidget renders with coffee arc painter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoffeeArcWidget(current: 9, target: 12),
          ),
        ),
      );

      expect(find.byType(CoffeeArcWidget), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('PointsRingWidget renders and counts points', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PointsRingWidget(totalPoints: 680000),
          ),
        ),
      );

      expect(find.text('Total points'), findsOneWidget);
      // Wait for counter animation to finish
      await tester.pumpAndSettle(const Duration(milliseconds: 1500));
      expect(find.text('680,000'), findsOneWidget);
    });

    testWidgets('SlidingTabIndicator switches tab on tap', (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SlidingTabIndicator(
                  selectedIndex: selected,
                  onTabSelected: (index) => setState(() => selected = index),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Eat more earn more'), findsOneWidget);
      expect(find.text('Gift'), findsOneWidget);

      await tester.tap(find.text('Gift'));
      await tester.pumpAndSettle();

      expect(selected, equals(1));
    });

    testWidgets('TierLadderWidget displays Silver, Gold, Platinum in order', (tester) async {
      const tiers = [
        TierInfo(name: 'Silver', subtitle: "You're here now", isCurrent: true),
        TierInfo(name: 'Gold', subtitle: "500 pts Remaining to become Gold", isCurrent: false),
        TierInfo(name: 'Platinum', subtitle: "You'll be here soon", isCurrent: false),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TierLadderWidget(tiers: tiers),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Silver'), findsOneWidget);
      expect(find.text("You're here now"), findsOneWidget);
      expect(find.text('Gold'), findsOneWidget);
      expect(find.text('Platinum'), findsOneWidget);
    });
  });
}
