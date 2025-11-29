import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';

class AppLockScreen extends StatelessWidget {
  const AppLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLockService = sl<IAppLockService>();
    final biometricService = sl<IBiometricService>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          onPressed: () async {
            // Update activity timestamp BEFORE authentication
            await appLockService.updateActivity();

            final result = await biometricService.authenticate(
              localizedReason: 'Authenticate to unlock the app',
            );

            if (!context.mounted) return;

            final authenticated = result.fold(
              (failure) => false,
              (success) => success,
            );

            if (authenticated) {
              // Capture context info before async gap
              final canPop = context.canPop();

              // Update activity again after successful authentication
              await appLockService.updateActivity();
              // Note: ISessionManager.startSession requires userId and token

              if (!context.mounted) return;

              if (canPop) {
                context.pop();
              } else {
                context.go('/home'); // fallback
              }
            }
          },
          child: const Text(
            "Unlock with Biometrics",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
