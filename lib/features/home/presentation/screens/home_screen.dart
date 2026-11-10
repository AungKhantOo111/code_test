import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/widgets/skeleton_shimmer.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../product/presentation/screens/product_hero_args.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/home_header.dart';
import '../widgets/nearby_shops_section.dart';
import '../widgets/product_section_row.dart';
import 'main_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainScreen(initialTab: 0);
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            // Airplane Mode / Offline indicator banner
            OfflineBanner(isOffline: state.isOffline),

            // Main Content
            Expanded(
              child: state.isLoading
                  ? const HomeSkeletonLoading()
                  : state.homeData == null
                      ? Center(
                          child: Text(
                            state.errorMessage ?? 'Unable to load content',
                            style: AppTypography.error,
                          ),
                        )
                      : RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () async {
                            context
                                .read<HomeBloc>()
                                .add(const RefreshHomeDataEvent());
                            await Future.delayed(
                                const Duration(milliseconds: 600));
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Warm Peach Header + Banner Top Section matching PDF Screen 8
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFFDE6CF),
                                        Color(0xFFFCEEE1),
                                        AppColors.background,
                                      ],
                                      stops: [0.0, 0.55, 1.0],
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: AppSpacing.md),
                                      // 1. Member Header
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppSpacing.lg),
                                        child: Builder(
                                          builder: (context) {
                                            final authUser = context
                                                .watch<AuthBloc>()
                                                .state
                                                .currentUser;
                                            final authFullName = authUser !=
                                                    null
                                                ? '${authUser.firstName} ${authUser.lastName ?? ""}'
                                                    .trim()
                                                : null;
                                            return HomeHeader(
                                              member: state.homeData!.member,
                                              displayNameOverride: authFullName,
                                              onLogout: () {
                                                context
                                                    .read<AuthBloc>()
                                                    .add(const LogoutEvent());
                                                context.go('/onboarding');
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.md),

                                      // 2. Banner Carousel
                                      BannerCarousel(
                                        banners: state.homeData!.banners,
                                      ),
                                      const SizedBox(height: AppSpacing.lg),
                                    ],
                                  ),
                                ),

                                // 3. Seasonal Specials (Wide/Big Cards matching PDF Screen 8)
                                ProductSectionRow(
                                  title: 'Seasonal specials',
                                  isLargeCard: true,
                                  products: state.homeData!.seasonalSpecials,
                                  onProductTap: (product, heroTag) =>
                                      context.push(
                                    '/product/${product.id}',
                                    extra: ProductHeroArgs(
                                      tag: heroTag,
                                      imageUrl: product.imageUrl,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),

                                // 4. Popular
                                ProductSectionRow(
                                  title: 'Popular 🔥',
                                  products: state.homeData!.popular,
                                  onProductTap: (product, heroTag) =>
                                      context.push(
                                    '/product/${product.id}',
                                    extra: ProductHeroArgs(
                                      tag: heroTag,
                                      imageUrl: product.imageUrl,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),

                                // 5. Order Again
                                ProductSectionRow(
                                  title: 'Order again',
                                  products: state.homeData!.orderAgain,
                                  onProductTap: (product, heroTag) =>
                                      context.push(
                                    '/product/${product.id}',
                                    extra: ProductHeroArgs(
                                      tag: heroTag,
                                      imageUrl: product.imageUrl,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.lg),

                                // 6. Nearby Shops Scenic Section
                                NearbyShopsSection(
                                  shops: state.homeData!.shops,
                                ),
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
}
