import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
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
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(left: 2).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr.aboutCoinTitle,     
              style: theme.textTheme.titleSmall!.copyWith(
                  fontSize: 18.sp,
                  color: isDark ? AppColors.textWhite : AppColors.primary)),
          AppSpacing.vertical(22),
          Text(
            textAlign: TextAlign.left,
            description, 
            style: theme.textTheme.bodyLarge!.copyWith(
              fontSize: 13.sp,
              color: isDark ? AppColors.textWhite : AppColors.gray2,
            ),
          ),
          AppSpacing.vertical(30),     
        ],
      ),
    ));
  }
}