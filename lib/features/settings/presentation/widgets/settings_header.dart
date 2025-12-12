import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'dart:io';

class SettingsHeader extends StatelessWidget {
  // New: Dynamic user data to mirror HomeHeader
  final String userName; 
  final String? avatarPath;

  const SettingsHeader({super.key,
  required this.userName, 
    this.avatarPath, 
  });


  ImageProvider _buildAvatarProvider() {
  if (avatarPath case final String path when path.isNotEmpty) {

    if (path.startsWith('assets/')) {
      return AssetImage(path);
    }
    if (path.startsWith('http')) {
      return NetworkImage(path);
    }
    return FileImage(File(path)); 
  }
  
  return const AssetImage(AppAssets.profileGirl); 
}



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: AppSpacing.paddingV23,
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 46.r,
              backgroundColor: isDark ? AppColors.darkBackAvatar : AppColors.backAvatar,
              backgroundImage: _buildAvatarProvider(),
            ),
            AppSpacing.gapH24,
            Text(
              userName,
              style: AppTextStyles.headlineMedium.copyWith(
                color: isDark ? AppColors.textWhite : theme.primaryColor,
              ),
            ),
            AppSpacing.gapH9,
          ],
        ),
      ),
    );
  }
}