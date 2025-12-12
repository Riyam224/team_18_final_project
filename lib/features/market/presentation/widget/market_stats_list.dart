import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:intl/intl.dart'; 

class MarketStatsList extends StatelessWidget {
  final Map<String, double> stats;

  const MarketStatsList({super.key, required this.stats});

  String _formatNumber(double number) {
    if (number >= 1000000000) {
      return '${NumberFormat.compact().format(number)} \$';
    } else if (number >= 1000000) {
      return '${NumberFormat.compact().format(number)} \$';
    } else if (number >= 1000) {
      return NumberFormat('#,##0').format(number);
    }
    return NumberFormat('#,##0.00').format(number);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final List<MapEntry<String, double>> statsEntries = stats.entries.toList();

    return SliverList.separated(
      itemCount: statsEntries.length,
      itemBuilder: (context, index) {
        final entry = statsEntries[index];
        final statName = entry.key;  
        final statValue = entry.value; 

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(statName,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: isDark ? AppColors.textWhiteSoft : AppColors.textGray,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      )),
                  AppSpacing.horizontal(8),
                  AppSvgWidget(
                    height: 16.h,
                    width: 16.w,
                    assetsName: AppAssets.infoOutline,
                  )
                ],
              ),
              Text(
                _formatNumber(statValue),
                style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textWhite : AppColors.primary),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: isDark
              ? AppColors.gray0.withValues(alpha: 0.3)
              : AppColors.gray4.withValues(alpha: 0.3),
          height: 1,
          thickness: 0.5,
        );
      },
    );
  }
}