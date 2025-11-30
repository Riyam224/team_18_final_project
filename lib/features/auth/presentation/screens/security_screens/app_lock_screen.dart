import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class AppLockScreen extends StatelessWidget {
  const AppLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLockService = sl<IAppLockService>();
    final biometricService = sl<IBiometricService>();
    final sessionManager = sl<ISessionManager>();

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

            // If biometrics are unavailable or not enrolled, fall back to login
            final available = await biometricService.isAvailable();
            final canCheckBiometric = available.getOrElse(() => false);
            final enrolledResult = await biometricService.isEnrolled();
            final isEnrolled = enrolledResult.getOrElse(() => false);

            if (!canCheckBiometric || !isEnrolled) {
              await sessionManager.endSession();
              await appLockService.unlock();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
              return;
            }

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
                  context.go(AppRoutes.home); // fallback
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
