import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/common_ui/buttons/primary_button.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/app_lock_service.dart';
import 'package:team_18_final_project/core/security/session_manager.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';

class VerifyFingerprintSuccessLoginScreen extends StatelessWidget {
  const VerifyFingerprintSuccessLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppSpacing.vertical(190),

              /// ---------------- SUCCESS ICON ----------------
              Stack(
                alignment: Alignment.center,
                children: [
                  /// Circle
                  SvgPicture.asset(
                    isDark ? AppAssets.whiteCircle : AppAssets.darkCircle,
                    width: AppSizing.successCircleSize,
                    height: AppSizing.successCircleSize,
                  ),

                  /// Checkmark
                  SvgPicture.asset(
                    isDark ? AppAssets.darkCheck : AppAssets.whiteCheck,
                    width: AppSizing.w86,
                    height: AppSizing.w86,
                  ),
                ],
              ),

              AppSpacing.vertical(106),

              /// ---------------- TITLE ----------------
              Text(
                AppStrings.youreVerified,
                textAlign: TextAlign.center,
                style: AppTextStyles.authSuccessTitle.copyWith(
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                ),
              ),

              AppSpacing.vSpace30,

              /// ---------------- SUBTITLE ----------------
              Padding(
                padding: AppSpacing.paddingH40,
                child: Text(
                  AppStrings.verificationComplete,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.authSuccessSubtitle.copyWith(
                    color:
                        isDark ? AppColors.textWhiteSoft2 : AppColors.textGray,
                  ),
                ),
              ),

              const Spacer(),

              /// ---------------- CONTINUE BUTTON ----------------
              Padding(
                padding: AppSpacing.paddingH20,
                child: PrimaryButton(
                  text: AppStrings.continueToHome,
                  color: isDark ? Colors.white : AppColors.primary,
                  textColor: isDark ? AppColors.primary : Colors.white,
                  onPressed: () async {
                    // Update activity timestamp to prevent app lock
                    await AppLockService.updateActivity();
                    await SessionManager.startSession();
                    if (context.mounted) {
                      context.go(AppRoutes.home);
                    }
                  },
                ),
              ),

              AppSpacing.vSpace50,
            ],
          ),
        ),
      ),
    );
  }
}
