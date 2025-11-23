import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/storage/shared_prefs.dart';
import 'package:team_18_final_project/features/splash/presentation/widgets/splash_icon.dart';

/// The initial screen displayed when the app launches.
///
/// Shows an animated splash screen with a background image and logo icon.
/// After a 2-second delay, navigates to either the onboarding screen or home screen
/// depending on whether the user has completed onboarding before.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// Controller for managing the fade-in animation
  late AnimationController _controller;

  /// Fade animation for the splash icon
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    // Initialize fade-in animation with 800ms duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Apply ease-in-out curve to the animation
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start the fade-in animation
    _controller.forward();

    // Initiate navigation sequence
    _navigate();
  }

  /// Handles navigation after splash screen delay.
  ///
  /// Waits 2 seconds, then checks if user has completed onboarding.
  /// Routes to home screen if completed, otherwise to onboarding.
  Future<void> _navigate() async {
    // Wait for 2 seconds to display the splash screen
    await Future.delayed(const Duration(milliseconds: 2000));

    // Check if user has completed onboarding
    final completed = await AppPrefs.isOnboardingCompleted();

    // Ensure widget is still mounted before navigation
    if (!mounted) return;

    // Navigate to appropriate screen based on onboarding status
    if (completed) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.onboarding);
    }
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
          // Background image
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

          // Animated splash icon (adapts to dark/light theme)
          FadeTransition(
            opacity: _fade,
            child: const SplashIcon(),
          ),
        ],
      ),
    );
  }
}
