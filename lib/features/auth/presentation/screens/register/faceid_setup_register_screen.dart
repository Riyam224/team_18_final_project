import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/buttons/secondary_button.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/auth/presentation/widgets/auth_background.dart';

import 'package:team_18_final_project/features/auth/presentation/widgets/auth_submit_button.dart';

class FaceIDSetupRegisterScreen extends StatelessWidget {
  const FaceIDSetupRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 88.h),

              /// ---------- HEADER ----------
              Text(
                AppStrings.setYourFaceID,
                style: AppTextStyles.authBiometricTitle.copyWith(
                  fontSize: 26.sp,
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                ),
              ),

              SizedBox(height: 33.h),

              SizedBox(
                width: 300.w,
                child: Text(
                  AppStrings.addFaceIDSecure,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.authBiometricDescription.copyWith(
                    fontSize: 18.sp,
                    color:
                        isDark ? AppColors.textWhiteSoft2 : AppColors.textGray,
                  ),
                ),
              ),

              SizedBox(height: 50.h),

              /// ---------- FACE ID ICON BOX ----------
              Container(
                width: 180.w,
                height: 180.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.textDark : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  isDark ? AppAssets.faceIDwhitebig : AppAssets.faceIDdarkbig,
                  width: 75.w,
                ),
              ),

              SizedBox(height: 20.h),

              Text(
                AppStrings.faceID,
                style: AppTextStyles.authBiometricLabel.copyWith(
                  fontSize: 18.sp,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),

              SizedBox(height: 145.h),

              /// ---------- BUTTONS ----------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: AppStrings.skip,
                        onPressed: () {},
                        borderColor: isDark ? Colors.white : AppColors.primary,
                        textColor: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: AuthSubmitButton(
                        text: AppStrings.continueButton,
                        onPressed: () {},
                      ),
                    ),
                  ],
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
