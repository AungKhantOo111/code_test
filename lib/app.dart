import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'routing/app_router.dart';

class JDonutsApp extends StatefulWidget {
  final AuthBloc? authBloc;
  const JDonutsApp({super.key, this.authBloc});

  @override
  State<JDonutsApp> createState() => _JDonutsAppState();
}

class _JDonutsAppState extends State<JDonutsApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = widget.authBloc ?? sl<AuthBloc>();
    _router = createAppRouter(_authBloc);
  }

  @override
  void dispose() {
    if (widget.authBloc == null) {
      _authBloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: "J'Donuts",
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.accentPink,
            surface: AppColors.surface,
          ),
          fontFamily: 'Inter',
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('my', 'MM'),
        ],
      ),
    );
  }
}
