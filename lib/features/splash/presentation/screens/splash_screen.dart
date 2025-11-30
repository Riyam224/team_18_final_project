import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:team_18_final_project/core/config/timing_config.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/storage/shared_prefs.dart';
import 'package:team_18_final_project/features/splash/presentation/widgets/splash_icon.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: TimingConfig.splashAnimationDuration,
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    try {
      // Ensure splash is visible for the animation duration
      await Future.delayed(TimingConfig.splashAnimationDuration);

      final user = FirebaseAuth.instance.currentUser;
      final hasSeenOnboarding = await AppPrefs.isOnboardingCompleted();

      // Registered users go straight to login after splash delay
      if (user != null) {
        if (!mounted) return;
        context.go(AppRoutes.login);
        return;
      }

      // First-time users see onboarding before login
      if (!hasSeenOnboarding) {
        if (!mounted) return;
        context.go(AppRoutes.onboarding);
        return;
      }
    } catch (_) {
      // On any error, default to onboarding flow
      if (!mounted) return;
      context.go(AppRoutes.onboarding);
      return;
    }

    // Returning users who already saw onboarding go to login
    if (!mounted) return;

    context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SizedBox(
              width: 638.w,
              height: double.infinity,
              child: Image.asset(
                AppAssets.splashBg,
                fit: BoxFit.contain,
              ),
            ),
          ),
          FadeTransition(
            opacity: _fade,
            child: const SplashIcon(),
          ),
        ],
      ),
    );
  }
}
