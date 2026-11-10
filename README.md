# J'Donuts Customer App (Senior Flutter Developer Code Test)

A production-grade, offline-first Flutter application built for the **Senior Flutter Developer Code Test (J'Donuts App)** across all 3 specified tasks (10 screens).

---

## 📦 Submission Artifacts & Screen Recording

- **🎬 Screen Recording Demo / Artifact 1:** [Google Drive Link 1](https://drive.google.com/file/d/1ZOD0Ktp9FBFhO-BrxwugW2bBoVOjAcV_/view?usp=drive_link)
- **📱 Build Artifact 2 (Android APK / iOS App):** [Google Drive Link 2](https://drive.google.com/file/d/1liY96H6x6Eu_MIXJnCyHCsdr5G703VHW/view?usp=drive_link)
- **🍏 Build Artifact 3 (iOS Simulator `.app` / Video):** [Google Drive Link 3](https://drive.google.com/file/d/1jCUsngPsAaaiLWtW8gF0jmuWup_xcGJq/view?usp=drive_link)

*(Note: Please ensure Google Drive link sharing permissions are set to **"Anyone with the link can view"**)*

---

## 📋 Table of Contents
1. [Overview & Features](#overview--features)
2. [Architecture & Folder Map](#architecture--folder-map)
3. [State Management & Dependency Injection](#state-management--dependency-injection)
4. [Offline Strategy & Data Layer](#offline-strategy--data-layer)
5. [Motion Design & Custom Animations](#motion-design--custom-animations)
6. [Prerequisites & Flutter Versions](#prerequisites--flutter-versions)
7. [How to Run](#how-to-run)
8. [Test Credentials & Verification](#test-credentials--verification)
9. [Automated Tests](#automated-tests)

---

## 📱 Overview & Features

### **Task 1: Authentication & Form Validation**
- **Complete Onboarding Flow:** Social placeholders (Google, Apple, Facebook), legal terms sheet.
- **Myanmar Phone Validation (`PhoneValidator`):** Normalizes inputs (strips spaces, dashes, leading `0` after `+95`), enforces `+959` prefix with 7–9 digits.
- **Auto-Advancing 6-Digit OTP (`OtpValidator`):** Auto-advance, backspace navigation, paste handler, shake animation on failure, lockout after 3 incorrect attempts, 5:00 resend countdown. Fake valid passcode: **`123456`**.
- **Name Validation (`NameValidator`):** First name required (1–50 chars, no digits, supports Myanmar Unicode `\u1000-\u109F`), optional last name.
- **Date of Birth (`DobValidator`):** 3-wheel Cupertino date picker bottom sheet, age verification ($\ge 13$ years old), leap year verification, checkmark progress ring, centered "Creating..." loading feedback.
- **Session Persistence:** Managed securely via `flutter_secure_storage`. Relaunching keeps session active.

### **Task 2: Offline-First Home & Product Detail**
- **Single Source of Truth:** Local Drift SQLite database with seeded initial catalog (Products, Banners, Shops, Member Profile).
- **Airplane Mode Ready:** Works seamlessly without internet; images cached with disk and bundled asset fallbacks.
- **Reachability Banner:** Displays real-time offline warning (`OfflineBanner`) when connectivity is severed.
- **Home Screen:** Member header, auto-advancing banner carousel, horizontal carousels with discount badges, nearby shops cards, skeleton loading states.
- **Product Detail:** Hero image transitions, quantity stepper (minimum 1), dynamic live MMK price calculation (`quantity * price`), add-to-cart feedback.

### **Task 3: Rewards Screen & Motion Design**
- **Points Ring (`PointsRingWidget`):** CustomPainter frosted donut ring sweeping from 0 to target progress while points smoothly count up to **680,000**.
- **Tier Ladder (`TierLadderWidget`):** Silver, Gold, Platinum staggered entrance; highlights current tier ("Silver - You're here now") with animated vertical connecting progress line.
- **Sliding Tabs (`SlidingTabIndicator`):** Fluid pill animation between *"Eat more earn more"* and *"Gift"* tabs.
- **Challenge Art (`CustomPainter`):**
  - Donut quarters progress ($4/4$ fully glazed with sprinkles, $1/4$ single quarter glazed).
  - Americano coffee arc ($9/12$ orange arc surrounding cup).
  - Attention cue (pulsing breathing animation) on complete challenges with interactive press feedback on **EARN**.
- **Sliding Bottom Navigation Pill:** Floating cyan navigation bar with active pink sliding pill displaying icon and text.

---

## 🏛 Architecture & Folder Map

This project strictly follows **Feature-First Clean Architecture**. **The domain layer is 100% pure Dart with zero Flutter dependencies.**

```text
lib/
├── app.dart                                # MaterialApp.router & theme bindings
├── main.dart                               # App entry point & dependency injection initialization
│
├── core/                                   # Cross-cutting concerns & shared tokens
│   ├── constants/                          # Named constants (kMinAge, fakeOtp, etc.)
│   ├── di/                                 # GetIt Service Locator dependency injection
│   ├── errors/                             # Typed Failures & Result<T, E> functional wrapper
│   ├── motion/                             # AppDurations & AppCurves (centralized animation tokens)
│   ├── network/                            # Network reachability service (connectivity_plus)
│   ├── storage/                            # Drift SQLite AppDatabase & versioned schema migrations
│   ├── theme/                              # AppColors, AppSpacing, AppTypography (Zero hardcoded colors)
│   └── widgets/                            # PrimaryButton, SkeletonBox, OfflineBanner
│
├── features/
│   ├── auth/                               # Task 1: Auth, Login, Registration
│   │   ├── data/repositories/              # FakeAuthRepositoryImpl (session & 1s delay)
│   │   ├── domain/                         # Pure Dart: User model, AuthRepository, validators
│   │   └── presentation/                   # Screens (Onboarding, Phone, OTP, Name, DOB), BLoC
│   │
│   ├── home/                               # Task 2: Home Catalog & Member Header
│   │   ├── data/repositories/              # HomeRepositoryImpl (Drift SQLite cache & asset seed)
│   │   ├── domain/                         # Pure Dart: HomeData, ProductItem, ShopItem, MemberProfile
│   │   └── presentation/                   # HomeScreen, BannerCarousel, BottomNavBar, BLoC
│   │
│   ├── product/                            # Task 2: Product Detail & Cart Stepper
│   │   ├── data/repositories/              # ProductRepositoryImpl
│   │   ├── domain/                         # Pure Dart: ProductRepository interface
│   │   └── presentation/                   # ProductDetailScreen, ProductDetailBloc
│   │
│   └── rewards/                            # Task 3: Rewards, Tier Ladder & Animated Challenges
│       ├── data/repositories/              # RewardsRepositoryImpl (Drift SQLite single source of truth)
│       ├── domain/                         # Pure Dart: ChallengeItem, TierInfo, RewardsData
│       └── presentation/                   # RewardsScreen, PointsRingWidget, TierLadder, Painters, BLoC
│
└── routing/
    └── app_router.dart                     # GoRouter configuration with auth session redirect guard
```

---

## ⚡ State Management & Dependency Injection

- **State Management:** **BLoC (`flutter_bloc`)** was chosen for its strict event-driven architecture, unidirectional data flow, explicit state transitions, and testability.
- **Dependency Injection:** **`get_it`** manages service locator singletons and factories. No services or repositories are directly instantiated inside widgets.

---

## 📴 Offline Strategy & Data Layer

1. **Local Database as Single Source of Truth:**
   - Powered by **Drift SQLite (`drift_flutter`)**.
   - On first launch, initial seed data is loaded from `assets/seed/initial_data.json` into Drift.
   - Both Home and Rewards read from the exact same local database record (`MemberProfilesTable`, `ChallengesTable`).
2. **Network Resilience:**
   - Network connectivity is tracked via `connectivity_plus`.
   - If offline, an `OfflineBanner` informs the user that cached local data is in use.
   - The app runs completely in **Airplane mode**.

---

## 🎨 Motion Design & Custom Animations

All motion tokens are defined in [`core/motion/app_motion.dart`](file:///Users/macbook/Desktop/Code%20Test/code_test/lib/core/motion/app_motion.dart):
- **Reduced Motion Support:** All animations query `MediaQuery.disableAnimations` via `AppDurations.getDuration(context, duration)` to safely eliminate or shorten motion for accessibility.
- **Points Ring Sweep:** Sweeps from 0 to 72% over 1200ms while the total points text counts up to `680,000`.
- **Donut Quarter CustomPainter:** Dynamically draws $1/4$ or $4/4$ frosted quarters with white sprinkles.
- **Coffee Arc CustomPainter:** Sweeps $250^\circ$ progress arc to $9/12$ surrounding the americano cup.
- **Tier Ladder Entrance:** Staggered slide/fade entrance with animated vertical connecting progress line fill.
- **Active Attention Cue:** Pulsing breathing animation on completed challenge buttons.
- **Sliding Nav Bar Pill:** Bottom bar selection pill smoothly slides between navigation tabs.

---

## 🛠 Prerequisites & Flutter Versions

- **Flutter SDK:** `>= 3.24.0` (Tested on Flutter 3.27.x / Dart 3.6.x)
- **Dart SDK:** `^3.10.4`
- **Platforms:** iOS Simulator & Android Emulator

---

## 🚀 How to Run

1. Clone or open the repository:
   ```bash
   cd code_test
   ```

2. Fetch dependencies:
   ```bash
   flutter pub get
   ```

3. Run code generation (if modifying Drift database):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the application:
   ```bash
   flutter run
   ```

5. Build Release Artifacts:
   - **Android APK:** `flutter build apk --release`
   - **iOS Simulator:** `flutter build ios --simulator`

---

## 🔑 Test Credentials & Verification

- **Valid Phone Format:** `09254135592` or `+959254135592` (Myanmar mobile numbers starting with 9 followed by 7–9 digits).
- **Valid Test OTP:** **`123456`** (Any other 6 digits will trigger shake animation and error).
- **Lockout Rule:** 3 failed OTP attempts locks entry until the timer resends.
- **Date of Birth:** Must be a valid date with age $\ge 13$ years old.

---

## 🧪 Automated Tests

Run the full automated test suite (42 unit and widget tests):
```bash
flutter test
```

Run static analysis:
```bash
flutter analyze
```
*(Result: 0 issues, perfectly clean analyzer)*
