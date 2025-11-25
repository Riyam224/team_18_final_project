import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/buttons/secondary_button.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_title_section.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_biometric_illustration.dart';

class SetFingerprintRegisterScreen extends StatelessWidget {
  const SetFingerprintRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 70.h),

                /// Title + Subtitle (reusable)
                const AuthTitleSection(
                  title: AppStrings.setYourFingerPrint,
                  subtitle: AppStrings.addFingerprintSecure,
                ),

                SizedBox(height: 70.h),

                /// Icon + description
                const AuthBiometricIllustration(
                  iconPath: AppAssets.fingerPrintBig,
                  description: AppStrings.placeFingerprintInstruction,
                ),
                SizedBox(height: 59.1.h),

                /// Skip Button (secondary)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 160.w,
                      child: SecondaryButton(
                        text: AppStrings.skip,
                        onPressed: () {
                          // TODO: go next screen
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
