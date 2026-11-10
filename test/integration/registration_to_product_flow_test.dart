import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:code_test/app.dart';
import 'package:code_test/core/di/injection.dart';
import 'package:code_test/core/storage/app_database.dart';
import 'package:code_test/features/auth/data/repositories/fake_auth_repository_impl.dart';
import 'package:code_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:code_test/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

void main() {
  late AuthBloc authBloc;
  late AppDatabase inMemoryDb;

  setUp(() async {
    await sl.reset();

    inMemoryDb = AppDatabase(NativeDatabase.memory());
    sl.registerLazySingleton<AppDatabase>(() => inMemoryDb);
    sl.registerLazySingleton<AuthRepository>(
      () => FakeAuthRepositoryImpl(delay: Duration.zero),
    );

    // Pre-insert a member and product so Home & Product Detail load immediately
    await inMemoryDb.into(inMemoryDb.memberProfilesTable).insert(
          MemberProfilesTableCompanion.insert(
            id: 'u_test',
            name: 'Aung Khant',
            photoUrl: 'assets/images/user_avatar.png',
            tier: 'Silver',
            points: 1290,
            nextTier: 'Gold',
            pointsToNextTier: 500,
            totalPoints: 680000,
            unreadNotifications: const Value(3),
          ),
        );

    await inMemoryDb.into(inMemoryDb.productsTable).insert(
          ProductsTableCompanion.insert(
            id: 'p_coconut',
            code: 'JD022123',
            name: 'Coconut Donut',
            priceMmk: 3200,
            imageUrl: 'assets/images/3.png',
            description: 'Delicious coconut glazed donut.',
            section: 'popular',
          ),
        );

    await initDependencies();
  });

  tearDown(() async {
    await inMemoryDb.close();
    authBloc.close();
    await sl.reset();
  });

  testWidgets(
      'Flow Test: Register -> Welcome -> Home -> Product Detail stepper',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    authBloc = sl<AuthBloc>();
    await tester.pumpWidget(JDonutsApp(authBloc: authBloc));
    await tester.pumpAndSettle();

    // 1. Onboarding Screen
    expect(find.text("LET'S GET STARTED"), findsOneWidget);
    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();

    // 2. Phone Screen
    expect(find.text('Enter your phone\nnumber'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '09254135592');
    await tester.pumpAndSettle();

    expect(find.text('CONTINUE'), findsOneWidget);
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();

    // 3. OTP Screen
    expect(find.text('Verify your number'), findsOneWidget);
    final otpFields = find.byType(TextField);
    expect(otpFields, findsNWidgets(6));

    // Fill in OTP '123456'
    for (int i = 0; i < 6; i++) {
      await tester.enterText(otpFields.at(i), '${i + 1}');
    }
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 4. Name Screen
    expect(find.text("What's your\nname?"), findsOneWidget);
    final nameFields = find.byType(TextField);
    await tester.enterText(nameFields.at(0), 'Aung');
    await tester.enterText(nameFields.at(1), 'Khant');
    await tester.pumpAndSettle();

    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();

    // 5. Date of Birth Screen
    expect(find.text("What's your\ndate of birth?"), findsOneWidget);

    // Tap day card to open birthday modal and confirm
    await tester.tap(find.text('Day'));
    await tester.pumpAndSettle();

    expect(find.text('Select your Birthday'), findsOneWidget);
    expect(find.text('SELECT'), findsOneWidget);
    await tester.tap(find.text('SELECT'));
    await tester.pumpAndSettle();

    // Tap CONTINUE on DOB screen
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 6. Welcome Screen
    expect(find.text('Welcome to the\nworld of J\'donuts'), findsOneWidget);
    expect(find.text("LET'S EXPLORE"), findsOneWidget);
    await tester.tap(find.text("LET'S EXPLORE"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // 7. Home Screen
    expect(find.text('Coconut Donut'), findsWidgets);

    // 8. Open Product Detail
    await tester.tap(find.text('Coconut Donut').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // 9. Product Detail Screen
    expect(find.text('Coconut Donut'), findsWidgets);
    expect(find.text('3,200 MMK'), findsWidgets);
    expect(find.text('1'), findsOneWidget); // Quantity stepper starts at 1

    // 10. Increment Quantity Stepper
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('2'), findsOneWidget); // Quantity increased to 2
    expect(find.text('6,400 MMK'), findsOneWidget); // Live price total (2 * 3200)

    // Tap Add to Cart
    await tester.tap(find.text('ADD TO CART'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  });
}
