import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_title_section.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_biometric_illustration.dart';

class VerifyFingerprintLoginScreen extends StatefulWidget {
  const VerifyFingerprintLoginScreen({super.key});

  @override
  State<VerifyFingerprintLoginScreen> createState() => _VerifyFingerprintLoginScreenState();
}

class _VerifyFingerprintLoginScreenState extends State<VerifyFingerprintLoginScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate fingerprint verification with a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.pushReplacement(AppRoutes.verifyFingerprintLoginSuccess);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppSpacing.vertical(88),

              /// ---------- TITLE SECTION ----------
              const AuthTitleSection(
                title: AppStrings.touchIdVerifyTitle,
                subtitle: "",
              ),

              AppSpacing.vSpace50,

              /// ---------- FINGERPRINT ILLUSTRATION ----------
              const AuthBiometricIllustration(
                iconPath: AppAssets.fingerPrintBig,
                description: AppStrings.touchIdFooter,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
