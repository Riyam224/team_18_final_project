import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class AppLockScreen extends StatelessWidget {
  const AppLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLockService = sl<IAppLockService>();
    final biometricService = sl<IBiometricService>();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.textDark,
          ),
          onPressed: () async {
            // Update activity timestamp BEFORE authentication
            await appLockService.updateActivity();

            final result = await biometricService.authenticate(
              localizedReason: AppStrings.authenticateToUnlock,
            );

            if (!context.mounted) return;

            final authenticated = result.fold(
              (failure) => false,
              (success) => success,
            );

            if (authenticated) {
              await appLockService.unlock(); // Clear persisted lock flag

              if (context.mounted) {
                final canPop = context.canPop();
                if (canPop) {
                  context.pop();
                } else {
                  context.go('/home'); // fallback
                }
              }
            }
          },
          child: Text(
            AppStrings.unlockWithBiometrics,
            style: AppTextStyles.titleMedium,
          ),
        ),
      ),
    );
  }
}
