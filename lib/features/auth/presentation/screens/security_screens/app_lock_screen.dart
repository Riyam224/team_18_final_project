import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/security/biometric_service.dart';

class AppLockScreen extends StatelessWidget {
  const AppLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          onPressed: () async {
            final bio = BiometricService();
            final ok = await bio.authenticate();

            if (ok) {
              if (context.canPop()) {
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
