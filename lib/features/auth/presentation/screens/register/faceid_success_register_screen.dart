import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/common_ui/buttons/primary_button.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class FaceidSuccessRegisterScreen extends StatelessWidget {
  const FaceidSuccessRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A1128) : const Color(0xFFF5F5F5),
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
            /// ---------------- TOP TITLE ----------------
            Positioned(
              top: AppSizing.h120,
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
                          width: AppSizing.iconXLarge,
                          height: AppSizing.iconXLarge,
                        ),

                        /// --- CHECKMARK ---
                        SvgPicture.asset(
                          isDark
                              ? AppAssets
                                  .faceIDDONElight // light checkmark in dark
                              : AppAssets
                                  .faceIDDonedark, // dark checkmark in light
                          width: AppSizing.iconMedium,
                          height: AppSizing.h20,
                        ),
                      ],
                    ),

                    AppSpacing.vSpace20,

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
              bottom: AppSizing.continueButtonBottom,
              left: AppSizing.w20,
              right: AppSizing.w20,
              child: PrimaryButton(
                text: AppStrings.continueButton,
                color: Colors.white,
                textColor: AppColors.primary,
                onPressed: () async {
                  final appLockService = sl<IAppLockService>();
                  final sessionManager = sl<ISessionManager>();

                  await appLockService.updateActivity();

                  final validResult = await sessionManager.isSessionValid();
                  validResult.fold(
                    (failure) => null, // Ignore errors
                    (valid) async {
                      if (!valid) {
                        await sessionManager.updateActivity();
                      }
                    },
                  );

                  if (context.mounted) {
                    context.go(AppRoutes.home);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
