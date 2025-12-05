import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage("assets/images/profile.png"),
            ),
            const SizedBox(width: 12),
            Text(
              AppStrings.greeting,
              style: theme.textTheme.titleMedium!.copyWith(
                color: isDark ? AppColors.textWhiteSoft : AppColors.textBlack,
                inherit: false,
              ),
            )
          ],
        ),
        Icon(
          Icons.notifications_none,
          size: 26,
          color: isDark ? AppColors.textWhite : AppColors.textGray,
        ),
      ],
    );
  }
}
