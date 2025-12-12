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
      return NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 2).format(number);
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

        return ListTile(
          title: Row(
            children: [
              Text(statName,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: isDark ? AppColors.textWhite : AppColors.primary,
                    fontSize: 12.sp,
                  )),
              AppSpacing.horizontal(16),
              AppSvgWidget(
                height: 12.h,
                width: 12.w,
                assetsName: AppAssets.infoOutline,
              )
            ],
          ),
          trailing: Text(
            _formatNumber(statValue),
            style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 12.sp,
                color: isDark ? AppColors.textWhite : AppColors.primary),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsetsDirectional.only(start: 15.r, end: 15.r),
          child: Divider(
              color: isDark ? AppColors.gray0 : AppColors.textWhiteSoft,
              height: 1),
        );
      },
    );
  }
}