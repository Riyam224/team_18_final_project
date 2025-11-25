import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_submit_button.dart';

class FingerprintSuccessRegisterScreen extends StatelessWidget {
  const FingerprintSuccessRegisterScreen({super.key});

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
                AppStrings.yourScanningIsComplete,
                textAlign: TextAlign.center,
                style: AppTextStyles.authSuccessTitle.copyWith(
                  fontSize: 22.sp,
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                ),
              ),

              SizedBox(height: 30.h),

              /// ---------------- SUBTITLE ----------------
              SizedBox(
                width: 300.w,
                child: Text(
                  AppStrings.youWillBeAbleToSignIn,
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
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: AuthSubmitButton(
                  text: AppStrings.continueButton,
                  onPressed: () {
                    // TODO: Next screen navigation
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
