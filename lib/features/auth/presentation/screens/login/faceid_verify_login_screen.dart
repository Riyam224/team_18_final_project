import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
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
              SizedBox(height: 160.h),

              /// ---------------- FACE ID BOX ----------------
              Container(
                width: 155.w,
                height: 180.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(28.r),
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
                          width: 72.w,
                          height: 72.h,
                        ),
                        SvgPicture.asset(
                          isDark
                              ? AppAssets.faceIDDONElight
                              : AppAssets.faceIDDonedark,
                          width: 26.w,
                          height: 26.h,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

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

              SizedBox(height: 60.h),

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

              SizedBox(height: 20.h),

              /// ---------------- SUBTITLE ----------------
              SizedBox(
                width: 310.w,
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
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SizedBox(
                  width: double.infinity,
                  child: AuthSubmitButton(
                    text: AppStrings.continueToHome,
                    onPressed: () {
                      // TODO: Navigate to home
                    },

                    /// OVERRIDE only on this screen:
                    /// White button in both themes
                  ),
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
