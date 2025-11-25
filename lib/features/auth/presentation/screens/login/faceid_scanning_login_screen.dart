import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';

class FaceIDScanningLoginScreen extends StatelessWidget {
  const FaceIDScanningLoginScreen({super.key});

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
            /// ---------------- FACE ID BOX ----------------
            Positioned(
              left: 110.w,
              top: 330.h,
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
                    /// ICON
                    SvgPicture.asset(
                      isDark
                          ? AppAssets.faceIDwhitebig
                          : AppAssets.faceIDdarkbig,
                      width: 80.w,
                      height: 80.h,
                    ),

                    SizedBox(height: 20.h),

                    /// LABEL
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
            /// ---------------- FOOTER TEXT ----------------
            Positioned(
              left: 0,
              right: 0,
              bottom: 120.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  AppStrings.faceIDPleaseWaitScanning,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.authBiometricScanInstruction.copyWith(
                    fontSize: 18.sp,
                    height: 1.4,
                    color: Colors.white, // EXACT like your screenshot
                    fontWeight: FontWeight.w500,
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
