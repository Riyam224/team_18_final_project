import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/l10n/app_localizations.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 23.h),
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 46.r,
              backgroundColor: isDark ? AppColors.darkBackAvatar : AppColors.backAvatar,
              child: ClipOval(
                child: Image.asset(
                  AppAssets.profile, 
                  fit: BoxFit.cover,
                  width: 92.w,
                  height: 92.h,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              AppLocalizations.of(context)!.name,
              style: AppTextStyles.headlineMedium.copyWith(
                color: isDark ? AppColors.textWhite : theme.primaryColor,
              ),
            ),
            SizedBox(height: 9.h),
          ],
        ),
      ),
    );
  }
}