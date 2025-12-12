import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class MarketCategoryChips extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const MarketCategoryChips({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categories.length, (index) {
          final selected = index == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: ChoiceChip(
              label: Text(
                categories[index],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: selected
                      ? AppColors.white
                      : isDark
                          ? AppColors.textWhiteSoft
                          : AppColors.gray2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              selected: selected,
              onSelected: (_) => onSelected(index),
              backgroundColor:
                  isDark ? AppColors.darkCard : AppColors.lightSurface,
              selectedColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            ),
          );
        }),
      ),
    );
  }
}
