import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../rewards/presentation/bloc/rewards_bloc.dart';
import '../../../rewards/presentation/bloc/rewards_event.dart';
import '../../../rewards/presentation/screens/rewards_screen.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'home_screen.dart';
import 'settings_view.dart';

class MainScreen extends StatefulWidget {
  final int initialTab;

  const MainScreen({super.key, this.initialTab = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentTabIndex;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTab;
  }

  void _handleTabSelected(int index) {
    setState(() => _currentTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (_) => sl<HomeBloc>()..add(const LoadHomeDataEvent()),
        ),
        BlocProvider<RewardsBloc>(
          create: (_) => sl<RewardsBloc>()..add(const LoadRewardsEvent()),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Main Tab Content (IndexedStack keeps scroll state and prevents reloading)
              Expanded(
                child: IndexedStack(
                  index: _currentTabIndex,
                  children: [
                    const HomeView(),
                    RewardsView(isVisible: _currentTabIndex == 1),
                    const _TabPlaceholderView(
                      title: 'Explore & Nearby',
                      icon: Icons.explore_outlined,
                      subtitle: 'Find your nearest J\'Donuts branch and check directions.',
                    ),
                    const _TabPlaceholderView(
                      title: 'Wallet & Cards',
                      icon: Icons.credit_card_outlined,
                      subtitle: 'Manage your J\'Donuts balance and digital gift cards.',
                    ),
                    const SettingsView(),
                  ],
                ),
              ),

              // Single Persistent Sliding Pill Bottom Navigation Bar
              CustomBottomNavBar(
                selectedIndex: _currentTabIndex,
                onItemSelected: _handleTabSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabPlaceholderView extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;

  const _TabPlaceholderView({
    required this.title,
    required this.icon,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
