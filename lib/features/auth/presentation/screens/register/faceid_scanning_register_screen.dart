import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';

class FaceIDScanningRegisterScreen extends StatelessWidget {
  const FaceIDScanningRegisterScreen({super.key});

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
            /// ---------------- TOP TEXT ----------------
            Positioned(
              left: 55.w,
              top: 119.h,
              child: SizedBox(
                width: 283.w,
                height: 44.h,
                child: Text(
                  AppStrings.placeFaceIDInstruction,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.authBiometricScanInstruction.copyWith(
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            /// ---------------- FACE ID BOX WITH TEXT INSIDE ----------------
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
                    SvgPicture.asset(
                      isDark
                          ? AppAssets.faceIDwhitebig
                          : AppAssets.faceIDdarkbig,
                      width: 80.w,
                      height: 80.h,
                    ),
                    SizedBox(height: 20.h),

                    /// TEXT INSIDE THE BOX
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
            ),

            /// ---------------- FOOTER TEXT ----------------
            Positioned(
              left: 21.w,
              top: 671.h,
              child: SizedBox(
                width: 333.65.w,
                height: 46.31.h,
                child: Text(
                  AppStrings.faceIDScanComplete,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.authBiometricScanInstruction.copyWith(
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
