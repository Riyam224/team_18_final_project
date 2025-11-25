import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_18_final_project/core/common_ui/buttons/primary_button.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';

class FaceidSuccessRegisterScreen extends StatelessWidget {
  const FaceidSuccessRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: 375.w,
        height: 812.h,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.faceIDbg),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            /// ---------------- TOP TITLE ----------------
            Positioned(
              top: 120.h,
              left: 0,
              right: 0,
              child: Text(
                AppStrings.youreReady,
                textAlign: TextAlign.center,
                style: AppTextStyles.authBiometricSuccessTitle.copyWith(
                  color: Colors.white,
                ),
              ),
            ),

            /// ---------------- SUCCESS BOX ----------------

            Positioned(
              left: 110.w,
              top: 327.h,
              child: Container(
                width: 155.w,
                height: 180.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(28.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        /// --- CIRCLE OUTLINE ---
                        SvgPicture.asset(
                          isDark
                              ? AppAssets
                                  .outlinedCircleWhite // white outline in dark
                              : AppAssets
                                  .outlinedCircleDark, // dark outline in light
                          width: 72.w,
                          height: 72.h,
                        ),

                        /// --- CHECKMARK ---
                        SvgPicture.asset(
                          isDark
                              ? AppAssets
                                  .faceIDDONElight // light checkmark in dark
                              : AppAssets
                                  .faceIDDonedark, // dark checkmark in light
                          width: 26.w,
                          height: 19.h,
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    /// --- FACE ID LABEL ---
                    Text(
                      AppStrings.faceID,
                      style: AppTextStyles.authBiometricIconLabel.copyWith(
                        color: isDark ? Colors.white : const Color(0xFF1D3A70),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ---------------- CONTINUE BUTTON ----------------
            Positioned(
              bottom: 70.h,
              left: 20.w,
              right: 20.w,
              child: PrimaryButton(
                text: AppStrings.continueButton,
                color: Colors.white,
                textColor: AppColors.primary,
                onPressed: () {
                  // TODO: next screen navigation
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
