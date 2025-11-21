import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/login_screen.dart';
import 'package:team_18_final_project/features/auth/presentation/screens/register_screen.dart';
import 'package:team_18_final_project/features/home/presentation/screens/home_screen.dart';
import 'package:team_18_final_project/features/market/presentation/screens/market_screen.dart';
import 'package:team_18_final_project/features/market/presentation/screens/coin_details_screen.dart';
import 'package:team_18_final_project/features/market/presentation/screens/buy_sell_screen.dart';
import 'package:team_18_final_project/features/market/presentation/screens/payment_screen.dart';
import 'package:team_18_final_project/features/portfolio/presentation/screens/portfolio_screen.dart';
import 'package:team_18_final_project/features/settings/presentation/screens/settings_screen.dart';
import 'package:team_18_final_project/features/splash/presentation/screens/splash_screen.dart';

class RouteGenerator {
  static GoRouter mainRoutingInOurApp = GoRouter(
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('404 Not Found'))),

    // todo initial route
    initialLocation: AppRoutes.splash,

    routes: [
      // -------------------------------
      // Splash &  Onboarding & Authentication
      // -------------------------------

      GoRoute(
          path: AppRoutes.splash,
          name: AppRoutes.splash,
          builder: (context, state) => const SplashScreen()),

      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // -------------------------------
      // Home
      // -------------------------------

      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // -------------------------------
      // Market
      // -------------------------------

      GoRoute(
        path: AppRoutes.market,
        name: AppRoutes.market,
        builder: (context, state) => const MarketScreen(),
      ),

      // -------------------------------
      // Coin Details
      // with dynamic parameter /coin/:id
      // -------------------------------

      GoRoute(
        path: '${AppRoutes.coinDetails}/:id',
        name: AppRoutes.coinDetails,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CoinDetailsScreen(coinId: id);
        },
      ),

      // -------------------------------
      // Buy / Sell Flow
      // with dynamic parameter /trade/:id
      // -------------------------------

      GoRoute(
        path: '${AppRoutes.buySell}/:id',
        name: AppRoutes.buySell,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BuySellScreen(coinId: id);
        },
      ),

      // -------------------------------
      // Payment
      // -------------------------------
      GoRoute(
        path: AppRoutes.payment,
        name: AppRoutes.payment,
        builder: (context, state) => const PaymentScreen(),
      ),

      // -------------------------------
      // Portfolio
      // -------------------------------

      GoRoute(
        path: AppRoutes.portfolio,
        name: AppRoutes.portfolio,
        builder: (context, state) => const PortfolioScreen(),
      ),

      // -------------------------------
      // Settings
      // -------------------------------

      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
