import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/app_router.dart';
import 'package:team_18_final_project/core/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await setupDependencies();

  // Set initial system UI overlay style
  AppTheme.setSystemUIOverlayStyle(ThemeMode.system);

  runApp(const FintechApp());
}

class FintechApp extends StatelessWidget {
  const FintechApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Team 18 Project',
          debugShowCheckedModeBanner: false,

          // Theme configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,

          // Routing
          routerConfig: RouteGenerator.mainRoutingInOurApp,

          // Builder to handle system UI overlay on theme changes
          builder: (context, child) {
            final brightness = MediaQuery.of(context).platformBrightness;
            final themeMode =
                brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
            AppTheme.setSystemUIOverlayStyle(themeMode);
            return child ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}
