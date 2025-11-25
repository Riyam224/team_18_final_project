import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';

class FaceIDScanningRegisterScreen extends StatelessWidget {
  const FaceIDScanningRegisterScreen({super.key});

  @override 
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: AppSizing.screenWidth,
        height: AppSizing.screenHeight,
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
              left: AppSizing.scanTextLeft,
              top: AppSizing.scanTextTop,
              child: SizedBox(
                width: AppSizing.w283,
                height: AppSizing.h44,
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
              left: AppSizing.faceIDBoxLeft,
              top: AppSizing.faceIDBoxTop,
              child: Container(
                width: AppSizing.faceIDContainerWidth,
                height: AppSizing.faceIDContainerHeight,
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      isDark
                          ? AppAssets.faceIDwhitebig
                          : AppAssets.faceIDdarkbig,
                      width: AppSizing.biometricIconLarge,
                      height: AppSizing.biometricIconLarge,
                    ),
                    AppSpacing.vSpace20,

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
              left: AppSizing.w20,
              top: AppSizing.footerTextTop,
              child: SizedBox(
                width: AppSizing.w333,
                height: AppSizing.h46,
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
