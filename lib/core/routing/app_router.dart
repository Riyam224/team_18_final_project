// //

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:team_18_final_project/core/common_ui/widgets/bottom_nav_shell.dart';
// import 'package:team_18_final_project/core/routing/route_names.dart';
// import 'package:team_18_final_project/features/auth/presentation/screens/login/fingerprint_verify_login_screen.dart';
// import 'package:team_18_final_project/features/auth/presentation/screens/register/faceid_scanning_register_screen.dart';
// import 'package:team_18_final_project/features/auth/presentation/screens/register/faceid_setup_register_screen.dart';
// import 'package:team_18_final_project/features/auth/presentation/screens/register/faceid_success_register_screen.dart';
// import 'package:team_18_final_project/features/auth/presentation/screens/register/fingerprint_setup_register_screen.dart';
// import 'package:team_18_final_project/features/auth/presentation/screens/register/fingerprint_success_register_screen.dart';

// // Splash + Auth + Onboarding
// import 'package:team_18_final_project/features/splash/presentation/screens/splash_screen.dart';
// import 'package:team_18_final_project/features/onboarding/presentation/screens/onboarding_screen.dart';
// import 'package:team_18_final_project/features/auth/presentation/screens/login/login_screen.dart';
// import 'package:team_18_final_project/features/auth/presentation/screens/register/register_screen.dart';

// // Main Tabs
// import 'package:team_18_final_project/features/home/presentation/screens/home_screen.dart';
// import 'package:team_18_final_project/features/market/presentation/screens/market_screen.dart';
// import 'package:team_18_final_project/features/portfolio/presentation/screens/portfolio_screen.dart';
// import 'package:team_18_final_project/features/settings/presentation/screens/settings_screen.dart';

// // Market Details Pages
// import 'package:team_18_final_project/features/market/presentation/screens/coin_details_screen.dart';
// import 'package:team_18_final_project/features/market/presentation/screens/buy_sell_screen.dart';
// import 'package:team_18_final_project/features/market/presentation/screens/payment_screen.dart';

// import '../../features/auth/presentation/screens/login/faceid_scanning_login_screen.dart';
// import '../../features/auth/presentation/screens/login/faceid_verify_login_screen.dart';
// import '../../features/auth/presentation/screens/login/fingerprint_verify_success_login_screen.dart';

// // ⭐ ADD THIS — it's missing
// final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

// class RouteGenerator {
//   static GoRouter mainRoutingInOurApp = GoRouter(
//     navigatorKey: appNavigatorKey, // 🔥 ADD THIS
//     errorBuilder: (context, state) =>
//         const Scaffold(body: Center(child: Text('404 Not Found'))),

//     // initial route
//     initialLocation: AppRoutes.login,

//     routes: [
//       // -------------------------------
//       // Splash, Onboarding, Authentication
//       // -------------------------------
//       GoRoute(
//         path: AppRoutes.splash,
//         name: AppRoutes.splash,
//         builder: (context, state) => const SplashScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.onboarding,
//         name: AppRoutes.onboarding,
//         builder: (context, state) => const OnboardingScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.login,
//         name: AppRoutes.login,
//         builder: (context, state) => const LoginScreen(),
//       ),
//       GoRoute(
//         path: AppRoutes.register,
//         name: AppRoutes.register,
//         builder: (context, state) => RegisterScreen(),
//       ),

//       GoRoute(
//         path: AppRoutes.setFingerprintRegister,
//         name: AppRoutes.setFingerprintRegister,
//         builder: (context, state) => const SetFingerprintRegisterScreen(),
//       ),

//       GoRoute(
//         path: AppRoutes.setFaceIDRegister,
//         name: AppRoutes.setFaceIDRegister,
//         builder: (context, state) => const FaceIDSetupRegisterScreen(),
//       ),

//       GoRoute(
//         path: AppRoutes.fingerprintSuccessRegister,
//         name: AppRoutes.fingerprintSuccessRegister,
//         builder: (context, state) => const FingerprintSuccessRegisterScreen(),
//       ),

//       // todo register face id scanning
//       GoRoute(
//           path: AppRoutes.faceIdScanningRegister,
//           name: AppRoutes.faceIdScanningRegister,
//           builder: (context, state) => const FaceIDScanningRegisterScreen()),

//       GoRoute(
//         path: AppRoutes.faceIdSuccessRegister,
//         name: AppRoutes.faceIdSuccessRegister,
//         builder: (context, state) => const FaceidSuccessRegisterScreen(),
//       ),

//       // login biometric verification routes can be added here

//       GoRoute(
//           path: AppRoutes.verifyFingerprintLogin,
//           name: AppRoutes.verifyFingerprintLogin,
//           builder: (context, state) => const VerifyFingerprintLoginScreen()),

//       GoRoute(
//           path: AppRoutes.verifyFingerprintLoginSuccess,
//           name: AppRoutes.verifyFingerprintLoginSuccess,
//           builder: (context, state) =>
//               const VerifyFingerprintSuccessLoginScreen()),

//       GoRoute(
//           path: AppRoutes.faceIdScanningLogin,
//           builder: (context, state) => const FaceIDScanningLoginScreen()),

//       GoRoute(
//           path: AppRoutes.faceIdVerifiedSuccessLogin,
//           name: AppRoutes.faceIdVerifiedSuccessLogin,
//           builder: (context, state) => const FaceIDVerifySuccessLoginScreen()),

//       // ==================================================
//       // MAIN APP WITH BOTTOM NAVIGATION
//       // Everything inside this ShellRoute shows the bottom nav
//       // ==================================================
//       ShellRoute(
//         builder: (context, state, child) => BottomNavShell(child: child),
//         routes: [
//           GoRoute(
//             path: AppRoutes.home,
//             name: AppRoutes.home,
//             builder: (context, state) => const HomeScreen(),
//           ),
//           GoRoute(
//             path: AppRoutes.market,
//             name: AppRoutes.market,
//             builder: (context, state) => const MarketScreen(),
//           ),
//           GoRoute(
//             path: AppRoutes.portfolio,
//             name: AppRoutes.portfolio,
//             builder: (context, state) => const PortfolioScreen(),
//           ),
//           GoRoute(
//             path: AppRoutes.settings,
//             name: AppRoutes.settings,
//             builder: (context, state) => const SettingsScreen(),
//           ),
//         ],
//       ),

//       // ==========================================
//       // MARKET DETAILS ROUTES (OUTSIDE BOTTOM NAV)
//       // These screens should NOT show the bottom nav
//       // ==========================================
//       GoRoute(
//         path: '${AppRoutes.coinDetails}/:id',
//         name: AppRoutes.coinDetails,
//         builder: (context, state) {
//           final id = state.pathParameters['id']!;
//           return CoinDetailsScreen(coinId: id);
//         },
//       ),

//       GoRoute(
//         path: '${AppRoutes.buySell}/:id',
//         name: AppRoutes.buySell,
//         builder: (context, state) {
//           final id = state.pathParameters['id']!;
//           return BuySellScreen(coinId: id);
//         },
//       ),

//       GoRoute(
//         path: AppRoutes.payment,
//         name: AppRoutes.payment,
//         builder: (context, state) => const PaymentScreen(),
//       ),
//     ],
//   );
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/common_ui/widgets/bottom_nav_shell.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
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

// 📌 Add this for App-Lock navigation from main.dart
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class RouteGenerator {
  static final GoRouter mainRoutingInOurApp = GoRouter(
    navigatorKey: appNavigatorKey,
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('404 Not Found'))),
    initialLocation: AppRoutes.register,
    routes: [
      // ==========================
      // AUTH, SPLASH, ONBOARDING
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
