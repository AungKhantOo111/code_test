import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/di/injection.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/screens/dob_screen.dart';
import '../features/auth/presentation/screens/name_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/auth/presentation/screens/phone_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/home/presentation/screens/welcome_screen.dart';
import '../features/product/presentation/bloc/product_detail_bloc.dart';
import '../features/product/presentation/bloc/product_detail_event.dart';
import '../features/product/presentation/screens/product_detail_screen.dart';
import '../features/product/presentation/screens/product_hero_args.dart';
import '../features/rewards/presentation/screens/rewards_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  bool? _wasLoggedIn;

  GoRouterRefreshStream(AuthBloc authBloc) {
    _wasLoggedIn = authBloc.state.currentUser != null;
    _subscription = authBloc.stream.listen((state) {
      final isLoggedIn = state.currentUser != null;
      if (_wasLoggedIn != isLoggedIn) {
        _wasLoggedIn = isLoggedIn;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

CustomTransitionPage<void> _buildSlidePage({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
      );
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

GoRouter createAppRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/onboarding',
    // Re-run the redirect guard whenever login state flips, so logout
    // navigates as soon as the session is actually cleared.
    refreshListenable: GoRouterRefreshStream(authBloc),
    redirect: (context, state) {
      final isLoggedIn = authBloc.state.currentUser != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth') ||
          state.matchedLocation == '/onboarding';

      // If logged in and trying to access auth screens, redirect to home
      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }

      // If not logged in and trying to access private screens, redirect to onboarding
      if (!isLoggedIn &&
          (state.matchedLocation == '/home' ||
              state.matchedLocation == '/welcome' ||
              state.matchedLocation.startsWith('/product') ||
              state.matchedLocation == '/rewards')) {
        return '/onboarding';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth/phone',
        pageBuilder: (context, state) => _buildSlidePage(
          context: context,
          state: state,
          child: const PhoneScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/otp',
        pageBuilder: (context, state) => _buildSlidePage(
          context: context,
          state: state,
          child: const OtpScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/name',
        pageBuilder: (context, state) => _buildSlidePage(
          context: context,
          state: state,
          child: const NameScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/dob',
        pageBuilder: (context, state) => _buildSlidePage(
          context: context,
          state: state,
          child: const DobScreen(),
        ),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id'] ?? 'p_coconut';
          return BlocProvider<ProductDetailBloc>(
            create: (_) => sl<ProductDetailBloc>()
              ..add(LoadProductDetailEvent(productId)),
            child: ProductDetailScreen(
              productId: productId,
              heroArgs: state.extra is ProductHeroArgs
                  ? state.extra as ProductHeroArgs
                  : null,
            ),
          );
        },
      ),
      GoRoute(
        path: '/rewards',
        builder: (context, state) => const RewardsScreen(),
      ),
    ],
  );
}
