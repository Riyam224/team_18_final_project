import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_18_final_project/core/common_ui/buttons/primary_button.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
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
              SizedBox(height: 190.93.h),

              /// ---------------- SUCCESS ICON ----------------
              Stack(
                alignment: Alignment.center,
                children: [
                  /// Circle
                  SvgPicture.asset(
                    isDark ? AppAssets.whiteCircle : AppAssets.darkCircle,
                    width: 110.w,
                    height: 110.w,
                  ),

                  /// Checkmark
                  SvgPicture.asset(
                    isDark ? AppAssets.darkCheck : AppAssets.whiteCheck,
                    width: 86.21.w,
                    height: 86.21.w,
                  ),
                ],
              ),

              SizedBox(height: 106.h),

              /// ---------------- TITLE ----------------
              Text(
                AppStrings.youreVerified,
                textAlign: TextAlign.center,
                style: AppTextStyles.authSuccessTitle.copyWith(
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                ),
              ),

              SizedBox(height: 30.h),

              /// ---------------- SUBTITLE ----------------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
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
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: PrimaryButton(
                  text: AppStrings.continueToHome,
                  color: isDark ? Colors.white : AppColors.primary,
                  textColor: isDark ? AppColors.primary : Colors.white,
                  onPressed: () {
                    // TODO: navigate to Home screen
                  },
                ),
              ),

              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}
