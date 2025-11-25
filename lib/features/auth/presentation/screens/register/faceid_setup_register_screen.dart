import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/buttons/secondary_button.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
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
              AppSpacing.vertical(88),

              /// ---------- HEADER ----------
              Text(
                AppStrings.setYourFaceID,
                style: AppTextStyles.authBiometricTitle.copyWith(
                  fontSize: 26.sp,
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                ),
              ),

              AppSpacing.vertical(33),

              SizedBox(
                width: AppSizing.w300,
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

              AppSpacing.vSpace50,

              /// ---------- FACE ID ICON BOX ----------
              Container(
                width: AppSizing.faceIDIconContainerSize,
                height: AppSizing.faceIDIconContainerSize,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.textDark : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  isDark ? AppAssets.faceIDwhitebig : AppAssets.faceIDdarkbig,
                  width: AppSizing.biometricIconMedium,
                ),
              ),

              AppSpacing.vSpace20,

              Text(
                AppStrings.faceID,
                style: AppTextStyles.authBiometricLabel.copyWith(
                  fontSize: 18.sp,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),

              AppSpacing.vertical(145),

              /// ---------- BUTTONS ----------
              Padding(
                padding: AppSpacing.paddingH16,
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
                    AppSpacing.hSpace20,
                    Expanded(
                      child: AuthSubmitButton(
                        text: AppStrings.continueButton,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vSpace40,
            ],
          ),
        ),
      ),
    );
  }
}
