import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';

class FaceIDScanningLoginScreen extends StatefulWidget {
  const FaceIDScanningLoginScreen({super.key});

  @override
  State<FaceIDScanningLoginScreen> createState() => _FaceIDScanningLoginScreenState();
}

class _FaceIDScanningLoginScreenState extends State<FaceIDScanningLoginScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate Face ID scanning with a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.pushReplacement(AppRoutes.faceIdVerifiedSuccessLogin);
      }
    });
  }

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
            /// ---------------- FACE ID BOX ----------------
            Positioned(
              left: AppSizing.faceIDBoxLeft,
              top: AppSizing.faceIDBoxTopAlt,
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
                    /// ICON
                    SvgPicture.asset(
                      isDark
                          ? AppAssets.faceIDwhitebig
                          : AppAssets.faceIDdarkbig,
                      width: AppSizing.biometricIconLarge,
                      height: AppSizing.biometricIconLarge,
                    ),

                    AppSpacing.vSpace20,

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
              bottom: AppSizing.footerTextBottom,
              child: Padding(
                padding: AppSpacing.paddingH24,
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
