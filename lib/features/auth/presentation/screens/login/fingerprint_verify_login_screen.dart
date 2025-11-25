import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_title_section.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_biometric_illustration.dart';

class VerifyFingerprintLoginScreen extends StatelessWidget {
  const VerifyFingerprintLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 88.h),

              /// ---------- TITLE SECTION ----------
              const AuthTitleSection(
                title: AppStrings.touchIdVerifyTitle,
                subtitle: "",
              ),

              SizedBox(height: 50.h),

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
