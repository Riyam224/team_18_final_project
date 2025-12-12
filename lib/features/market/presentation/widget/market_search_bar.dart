import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class MarketSearchBar extends StatelessWidget {
  final String hintText;
  final Widget? trailing;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const MarketSearchBar({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.paddingH16V14,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppSizing.radius16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: isDark ? AppColors.textWhiteSoft : AppColors.gray3,
            size: 22.sp,
          ),
          AppSpacing.gapW12,
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textGrayLight : AppColors.gray3,
                ),
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
