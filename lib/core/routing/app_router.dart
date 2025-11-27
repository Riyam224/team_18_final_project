import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/common_ui/widgets/bottom_nav_shell.dart';
import 'package:team_18_final_project/core/observers/app_route_observer.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/features/auth/presentation/debug/biometric_debug_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/login/faceid_scanning_login_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/login/faceid_verify_login_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/login/fingerprint_verify_login_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/login/fingerprint_verify_success_login_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/login/login_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/register/faceid_scanning_register_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/register/faceid_setup_register_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/register/faceid_success_register_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/register/fingerprint_setup_register_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/register/fingerprint_success_register_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/register/register_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/security_screens/app_lock_screen.dart';
import 'package:team_18_final_project/features/home/presentation/screens/home_screen.dart';
import 'package:team_18_final_project/features/market/presentation/screens/buy_sell_screen.dart';
import 'package:team_18_final_project/features/market/presentation/screens/coin_details_screen.dart';
import 'package:team_18_final_project/features/market/presentation/screens/market_screen.dart';
import 'package:team_18_final_project/features/market/presentation/screens/payment_screen.dart';
import 'package:team_18_final_project/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:team_18_final_project/features/portfolio/presentation/screens/portfolio_screen.dart';
import 'package:team_18_final_project/features/settings/presentation/screens/settings_screen.dart';
import 'package:team_18_final_project/features/splash/presentation/screens/splash_screen.dart';

import '../../features/auth/presentation/debug/biometric_test_screen.dart';

// 📌 Add this for App-Lock navigation from main.dart
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class RouteGenerator {
  static final GoRouter mainRoutingInOurApp = GoRouter(
    navigatorKey: appNavigatorKey,
    observers: [appRouteObserver],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('404 Not Found'))),
    // Start from splash screen as per splash_onboarding feature
    initialLocation: AppRoutes.splash,
    routes: [
      // ==========================
      // SPLASH, ONBOARDING, AUTH
      // ==========================
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => RegisterScreen(),
      ),

      // ==========================
      // REGISTER BIOMETRIC FLOWS
      // ==========================
      GoRoute(
        path: AppRoutes.setFingerprintRegister,
        builder: (_, __) => const SetFingerprintRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.setFaceIDRegister,
        builder: (_, __) => const FaceIDSetupRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.fingerprintSuccessRegister,
        builder: (_, __) => const FingerprintSuccessRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.faceIdScanningRegister,
        builder: (_, __) => const FaceIDScanningRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.faceIdSuccessRegister,
        builder: (_, __) => const FaceidSuccessRegisterScreen(),
      ),

      // ==========================
      // LOGIN BIOMETRIC FLOWS
      // ==========================
      GoRoute(
        path: AppRoutes.verifyFingerprintLogin,
        builder: (_, __) => const VerifyFingerprintLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyFingerprintLoginSuccess,
        builder: (_, __) => const VerifyFingerprintSuccessLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.faceIdScanningLogin,
        builder: (_, __) => const FaceIDScanningLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.faceIdVerifiedSuccessLogin,
        builder: (_, __) => const FaceIDVerifySuccessLoginScreen(),
      ),

      // ==========================
      // 🔒 APP LOCK SCREEN
      // ==========================
      GoRoute(
        path: '/app-lock',
        builder: (_, __) => const AppLockScreen(),
      ),

      // ==========================
      // DEBUG ROUTES (for testing)
      // ==========================
      GoRoute(
        path: '/biometric-test',
        builder: (_, __) => const BiometricTestScreen(),
      ),
      GoRoute(
        path: '/debug-biometrics',
        builder: (_, __) => BiometricDebugScreen(),
      ),

      // ==========================
      // MAIN APP w/ BOTTOM NAV
      // ==========================
      ShellRoute(
        builder: (context, state, child) => BottomNavShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.market,
            builder: (_, __) => const MarketScreen(),
          ),
          GoRoute(
            path: AppRoutes.portfolio,
            builder: (_, __) => const PortfolioScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, __) => const SettingsScreen(),
          ),
        ],
      ),

      // ==========================
      // DETAILS (NO BOTTOM NAV)
      // ==========================
      GoRoute(
        path: '${AppRoutes.coinDetails}/:id',
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return CoinDetailsScreen(coinId: id);
        },
      ),
      GoRoute(
        path: '${AppRoutes.buySell}/:id',
        builder: (_, state) {
          final id = state.pathParameters['id']!;
          return BuySellScreen(coinId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.payment,
        builder: (_, __) => const PaymentScreen(),
      ),
    ],
  );
}
