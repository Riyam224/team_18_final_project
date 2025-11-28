import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/app_lock_service.dart';
import 'package:team_18_final_project/core/security/session_manager.dart';
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

    final hasValidSession = await SessionManager.hasValidSession();
    if (hasValidSession) {
      await AppLockService.updateActivity();
      final shouldLock = await AppLockService.shouldLock();
      if (!mounted) return;
      if (shouldLock) {
        context.go(AppRoutes.appLock);
      } else {
        context.go(AppRoutes.home);
      }
      return;
    }

    if (!mounted) return;
    // Always send the user to the login screen; downstream flows enforce biometrics
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
