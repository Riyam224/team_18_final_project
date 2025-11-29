import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_submit_button.dart';

class FaceIDVerifySuccessLoginScreen extends StatelessWidget {
  const FaceIDVerifySuccessLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppSpacing.vertical(160),

              /// ---------------- FACE ID BOX ----------------
              Container(
                width: AppSizing.faceIDContainerWidth,
                height: AppSizing.faceIDContainerHeight,
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Circle outline + checkmark
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          isDark
                              ? AppAssets.outlinedCircleWhite
                              : AppAssets.outlinedCircleDark,
                          width: AppSizing.iconXLarge,
                          height: AppSizing.iconXLarge,
                        ),
                        SvgPicture.asset(
                          isDark
                              ? AppAssets.faceIDDONElight
                              : AppAssets.faceIDDonedark,
                          width: AppSizing.iconMedium,
                          height: AppSizing.iconMedium,
                        ),
                      ],
                    ),
                    AppSpacing.vSpace20,

                    Text(
                      AppStrings.faceID,
                      style: AppTextStyles.authBiometricIconLabel.copyWith(
                        fontSize: 20.sp,
                        color: isDark ? Colors.white : const Color(0xFF1D3A70),
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vertical(60),

              /// ---------------- TITLE ----------------
              Text(
                AppStrings.youreVerified,
                textAlign: TextAlign.center,
                style: AppTextStyles.authSuccessTitle.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                ),
              ),

              AppSpacing.vSpace20,

              /// ---------------- SUBTITLE ----------------
              SizedBox(
                width: AppSizing.w310,
                child: Text(
                  AppStrings.verificationCompleteTransactions,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.authSubtitle.copyWith(
                    fontSize: 16.sp,
                    height: 1.4,
                    color:
                        isDark ? AppColors.textWhiteSoft2 : AppColors.textGray,
                  ),
                ),
              ),

              const Spacer(),

              /// ---------------- CONTINUE BUTTON ----------------
              Padding(
                padding: AppSpacing.paddingH20,
                child: SizedBox(
                  width: double.infinity,
                  child: AuthSubmitButton(
                    text: AppStrings.continueToHome,
                    onPressed: () async {
                      final appLockService = sl<IAppLockService>();

                      await appLockService.resetLock();
                      // Note: ISessionManager.startSession requires userId and token
                      // These should come from the authentication flow state

                      if (context.mounted) {
                        context.go(AppRoutes.home);
                      }
                    },

                    /// OVERRIDE only on this screen:
                    /// White button in both themes
                  ),
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
