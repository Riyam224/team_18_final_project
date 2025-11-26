// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:team_18_final_project/core/di/di.dart';
// import 'package:team_18_final_project/core/routing/app_router.dart';
// import 'package:team_18_final_project/core/utils/app_theme.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize dependencies
//   await setupDependencies();

//   // Set initial system UI overlay style
//   AppTheme.setSystemUIOverlayStyle(ThemeMode.system);

//   runApp(const FintechApp());
// }

// class FintechApp extends StatelessWidget {
//   const FintechApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp.router(
//           title: 'Team 18 Project',
//           debugShowCheckedModeBanner: false,

//           // FULL NEW THEMES
//           theme: AppTheme.lightTheme,
//           darkTheme: AppTheme.darkTheme,
//           themeMode: ThemeMode.system,

//           routerConfig: RouteGenerator.mainRoutingInOurApp,
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_application/secure_application.dart';

import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/app_router.dart';
import 'package:team_18_final_project/core/security/app_lock_service.dart';
import 'package:team_18_final_project/core/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DI
  await setupDependencies();

  // System UI Theme
  AppTheme.setSystemUIOverlayStyle(ThemeMode.system);

  runApp(const FintechApp());
}

class FintechApp extends StatefulWidget {
  const FintechApp({super.key});

  @override
  State<FintechApp> createState() => _FintechAppState();
}

class _FintechAppState extends State<FintechApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Save time when app launches
    AppLockService.updateActivity();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // Check if app should lock
      final shouldLock = await AppLockService.shouldLock();
      if (shouldLock) {
        appNavigatorKey.currentContext?.go('/app-lock');
      }
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // Update timestamp
      await AppLockService.updateActivity();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return SecureApplication(
          // 🔒 blur & block recording
          child: MaterialApp.router(
            title: 'Team 18 Project',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: RouteGenerator.mainRoutingInOurApp,
          ),
        );
      },
    );
  }
}
