import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class RootWarningScreen extends StatelessWidget {
  const RootWarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textBlack;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.gray6,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Security Warning',
              style: AppTextStyles.headlineMedium.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your device appears to be rooted or jailbroken. This can expose your data to risk. '
              'Continue at your own risk or exit the app.',
              style: AppTextStyles.bodyMedium.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.go(AppRoutes.login);
              },
              child: const Text('Continue anyway'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Exit'),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.securityWarningFooter,
              style: AppTextStyles.bodySmall.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
