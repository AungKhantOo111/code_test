import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:code_test/app.dart';
import 'package:code_test/features/auth/data/repositories/fake_auth_repository_impl.dart';
import 'package:code_test/features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  late AuthBloc authBloc;

  setUp(() {
    authBloc = AuthBloc(authRepository: FakeAuthRepositoryImpl());
  });

  tearDown(() {
    authBloc.close();
  });

  testWidgets('Onboarding loads and navigates to Phone Screen on Get Started with BLoC',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      JDonutsApp(authBloc: authBloc),
    );
    await tester.pumpAndSettle();

    // Verify Onboarding screen content
    expect(find.text("LET'S GET STARTED"), findsOneWidget);

    // Tap "Let's get started"
    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();

    // Verify Phone screen appears
    expect(find.text('Enter your phone\nnumber'), findsOneWidget);
    expect(find.text('+95'), findsOneWidget);

    // Enter a valid phone number
    await tester.enterText(find.byType(TextField), '09254135592');
    await tester.pumpAndSettle();

    // Verify Continue button is present
    expect(find.text('CONTINUE'), findsOneWidget);
  });
}
