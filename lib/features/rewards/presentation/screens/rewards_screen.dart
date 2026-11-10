import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/widgets/skeleton_shimmer.dart';
import '../../../home/presentation/screens/main_screen.dart';
import '../bloc/rewards_bloc.dart';
import '../bloc/rewards_event.dart';
import '../bloc/rewards_state.dart';
import '../widgets/challenge_card.dart';
import '../widgets/points_ring_widget.dart';
import '../widgets/sliding_tab_indicator.dart';
import '../widgets/tier_ladder_widget.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainScreen(initialTab: 1);
  }
}

class RewardsView extends StatefulWidget {
  final bool isVisible;

  const RewardsView({super.key, this.isVisible = true});

  @override
  State<RewardsView> createState() => _RewardsViewState();
}

class _RewardsViewState extends State<RewardsView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;
  late final Animation<double> _badgePopAnimation;
  int _animationKey = 0;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: AppDurations.slow,
    );

    _badgePopAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.1, 0.7, curve: AppCurves.elasticOut),
      ),
    );

    if (widget.isVisible) {
      _staggerController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant RewardsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _replayAnimations();
    }
  }

  void _replayAnimations() {
    if (!mounted) return;
    setState(() {
      _animationKey++;
    });
    _staggerController.reset();
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RewardsBloc, RewardsState>(
      listenWhen: (previous, current) =>
          current.lastClaimedId != null &&
          current.lastClaimedId != previous.lastClaimedId,
      listener: (context, state) {
        if (state.lastClaimedId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Points claimed successfully! +100 pts'),
              duration: Duration(milliseconds: 1200),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
      builder: (context, state) {
        final data = state.data;

        return Column(
          children: [
            const OfflineBanner(isOffline: false),
            Expanded(
              child: state.isLoading && data == null
                  ? _buildLoadingSkeleton()
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        context
                            .read<RewardsBloc>()
                            .add(const LoadRewardsEvent());
                        _replayAnimations();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            // Header: "J' Donuts Rewards" and animated "Rewards 3" badge
                            _buildHeader(data?.unreadNotifications ?? 3),
                            const SizedBox(height: 20),

                            // Tier Ladder & Donut Points Ring Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: TierLadderWidget(
                                    key: ValueKey('ladder_$_animationKey'),
                                    tiers: data?.tiers ?? [],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 6,
                                  child: Center(
                                    child: PointsRingWidget(
                                      key: ValueKey('points_$_animationKey'),
                                      totalPoints:
                                          data?.totalPoints ?? 680000,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Sliding Tabs: "Eat more earn more" and "Gift"
                            SlidingTabIndicator(
                              selectedIndex: state.selectedTabIndex,
                              onTabSelected: (index) {
                                context
                                    .read<RewardsBloc>()
                                    .add(TabChangedEvent(index));
                              },
                            ),
                            const SizedBox(height: 20),

                            // Animated Tab Content Switcher
                            AnimatedSwitcher(
                              duration: AppDurations.getDuration(
                                  context, AppDurations.standard),
                              switchInCurve: AppCurves.easeOut,
                              switchOutCurve: Curves.easeIn,
                              layoutBuilder: (currentChild, previousChildren) {
                                return Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    ...previousChildren.map(
                                      (c) => Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: c,
                                      ),
                                    ),
                                    ?currentChild,
                                  ],
                                );
                              },
                              child: state.selectedTabIndex == 0
                                  ? _buildChallengesList(state)
                                  : _buildGiftTabContent(),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(int badgeCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "J' Donuts Rewards",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        // Rewards Badge that pops in on entry
        ScaleTransition(
          scale: _badgePopAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentOrange,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusPill),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentOrange.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Rewards',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accentOrange,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChallengesList(RewardsState state) {
    final challenges = state.data?.challenges ?? [];

    if (challenges.isEmpty) {
      return Container(
        key: const ValueKey('empty_challenges'),
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: const Text(
          'No challenges available right now.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      key: const ValueKey('challenges_list'),
      children: List.generate(challenges.length, (index) {
        final challenge = challenges[index];
        return ChallengeCard(
          challenge: challenge,
          index: index,
          animationController: _staggerController,
          onEarnPressed: () {
            context.read<RewardsBloc>().add(EarnChallengeEvent(challenge.id));
          },
        );
      }),
    );
  }

  Widget _buildGiftTabContent() {
    return Container(
      key: const ValueKey('gift_tab'),
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Gifts bring people together',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select an amount and send out to your loved ones.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gift Cards coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              'SEND GIFT CARD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 180, height: 28),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                  child: SkeletonBox(width: double.infinity, height: 140)),
              SizedBox(width: 16),
              SkeletonBox(width: 140, height: 140, borderRadius: 70),
            ],
          ),
          SizedBox(height: 24),
          SkeletonBox(width: double.infinity, height: 48, borderRadius: 24),
          SizedBox(height: 20),
          SkeletonBox(width: double.infinity, height: 100, borderRadius: 16),
          SizedBox(height: 16),
          SkeletonBox(width: double.infinity, height: 100, borderRadius: 16),
        ],
      ),
    );
  }
}
