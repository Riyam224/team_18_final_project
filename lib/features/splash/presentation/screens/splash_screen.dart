import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Splash Screen',
          style: AppTextStyles.headlineMedium,
        ),
      ),
    );
  }
}
