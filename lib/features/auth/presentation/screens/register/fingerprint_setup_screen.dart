import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_title_section.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_biometric_illustration.dart';

class SetFingerprintScreen extends StatelessWidget {
  const SetFingerprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 70.h),

              /// Title + Subtitle (reusable)
              const AuthTitleSection(
                title: "Set Your Finger Print",
                subtitle:
                    "Add a fingerprint to make your account\nmore secure.",
              ),

              SizedBox(height: 40.h),

              /// Icon + description
              const AuthBiometricIllustration(
                iconPath: AppAssets.fingerPrintIcon,
                description:
                    "Place your finger in fingerprint\nsensor until the icon completely",
              ),

              const Spacer(),

              /// Skip Button (secondary)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: AuthSecondaryButton(
                  text: "Skip",
                  onTap: () {
                    // TODO: go next screen
                  },
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
