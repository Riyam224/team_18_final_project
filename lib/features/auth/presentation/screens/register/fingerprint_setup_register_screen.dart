import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/common_ui/buttons/secondary_button.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
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
                AppSpacing.vertical(70),

                /// Title + Subtitle (reusable)
                const AuthTitleSection(
                  title: AppStrings.setYourFingerPrint,
                  subtitle: AppStrings.addFingerprintSecure,
                ),

                AppSpacing.vSpace70,

                /// Icon + description
                const AuthBiometricIllustration(
                  iconPath: AppAssets.fingerPrintBig,
                  description: AppStrings.placeFingerprintInstruction,
                ),
                AppSpacing.vertical(59),

                /// Skip Button (secondary)
                Padding(
                  padding: AppSpacing.paddingH16,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: AppSizing.w160,
                      child: SecondaryButton(
                        text: AppStrings.skip,
                        onPressed: () {
                          // TODO: go next screen
                        },
                      ),
                    ),
                  ),
                ),

                AppSpacing.vSpace40,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
