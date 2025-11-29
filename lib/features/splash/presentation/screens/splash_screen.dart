import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
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
  late final ISessionManager _sessionManager;
  late final IAppLockService _appLockService;

  @override
  void initState() {
    super.initState();

    // Inject services from DI container
    _sessionManager = sl<ISessionManager>();
    _appLockService = sl<IAppLockService>();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final isValidResult = await _sessionManager.isSessionValid();
        final hasValidSession = isValidResult.fold((_) => false, (valid) => valid);

        if (hasValidSession) {
          // Registered user - wait 3 seconds
          await Future.delayed(const Duration(milliseconds: 3000));

          await _appLockService.updateActivity();

          final shouldLockResult = await _appLockService.isLocked();
          final shouldLock = shouldLockResult.fold((_) => false, (locked) => locked);

          if (!mounted) return;
          if (shouldLock) {
            context.go(AppRoutes.appLock);
          } else {
            context.go(AppRoutes.home);
          }
          return;
        }
      }
    } catch (_) {
      // Fall through to non-registered flow on any auth/session error
    }

    // Non-registered user - wait 2 seconds
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    // Check if user has seen onboarding
    final hasSeenOnboarding = await AppPrefs.isOnboardingCompleted();

    if (!mounted) return;

    if (hasSeenOnboarding) {
      // User has seen onboarding before, go to login
      context.go(AppRoutes.login);
    } else {
      // First time user, show onboarding
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
