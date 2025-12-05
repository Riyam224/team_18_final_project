import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/utils/app_providers_wrapper.dart';
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
    return const AppProvidersWrapper(); 
  }
}