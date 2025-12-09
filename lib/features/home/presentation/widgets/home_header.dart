import 'dart:io';

import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? avatarPath;

  const HomeHeader({
    super.key,
    required this.userName,
    this.avatarPath,
  });

  ImageProvider _buildAvatarProvider() {
    if (avatarPath != null && avatarPath!.isNotEmpty) {
      if (avatarPath!.startsWith('assets/')) {
        return AssetImage(avatarPath!);
      }
      if (avatarPath!.startsWith('http')) {
        return NetworkImage(avatarPath!);
      }
      return FileImage(File(avatarPath!));
    }
    return const AssetImage(AppAssets.profileGirl);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final waveColor = isDark ? AppColors.textWhite : AppColors.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: AppSizing.radius22,
              backgroundImage: _buildAvatarProvider(),
              backgroundColor: isDark ? AppColors.darkCard : AppColors.gray5,
            ),
            AppSpacing.gapW12,
            Row(
              children: [
                Text(
                  AppStrings.greetingTemplate(userName),
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: isDark ? AppColors.textWhite : AppColors.textBlack,
                  ),
                ),
                AppSpacing.gapW8,
                Icon(
                  Icons.waving_hand,
                  color: waveColor,
                  size: AppSizing.iconMedium,
                ),
              ],
            ),
          ],
        ),
        Icon(
          Icons.notifications_none,
          size: AppSizing.iconMedium,
          color: isDark ? AppColors.textWhite : AppColors.textGray,
        ),
      ],
    );
  }
}
