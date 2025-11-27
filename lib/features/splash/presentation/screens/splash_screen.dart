import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/local_auth_service.dart';
import 'package:team_18_final_project/core/security/secure_storage_service.dart';
import 'package:team_18_final_project/core/security/session_manager.dart';
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
      duration: const Duration(milliseconds: 800),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    final onboardingCompleted = await AppPrefs.isOnboardingCompleted();
    final hasSession = await SessionManager.hasValidSession();

    if (!mounted) return;

    // If a valid session exists, head straight to the app
    if (hasSession) {
      context.go(AppRoutes.home);
      return;
    }

    // If onboarding not done, continue to onboarding
    if (!onboardingCompleted) {
      context.go(AppRoutes.onboarding);
      return;
    }

    // Onboarding done but no active session: prefer biometric login when available
    final biometricsEnabled = await SecureStorageService.isBiometricEnabled();
    if (biometricsEnabled) {
      final biometricsAvailable = await LocalAuthService.isBiometricAvailable();
      if (biometricsAvailable) {
        final type = await SecureStorageService.getBiometricType();
        final targetRoute = type == 'face'
            ? AppRoutes.faceIdScanningLogin
            : AppRoutes.verifyFingerprintLogin;
        context.go(targetRoute);
        return;
      }
    }

    // Default to credentials login
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
