import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class BitcoinTitleDescription extends StatelessWidget {
  final String description;

  const BitcoinTitleDescription({
    super.key,
    required this.description,  
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr.aboutCoinTitle,
            style: theme.textTheme.titleSmall!.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textWhite : AppColors.primary)),
        AppSpacing.vertical(16),
        Text(
          textAlign: TextAlign.left,
          description,
          style: theme.textTheme.bodyLarge!.copyWith(
            fontSize: 14.sp,
            height: 1.5,
            color: isDark ? AppColors.textWhiteSoft : AppColors.textGray,
          ),
        ),
      ],
    );
  }
}