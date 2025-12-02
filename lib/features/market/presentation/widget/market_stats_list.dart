import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class MarketStatsList extends StatelessWidget {
  const MarketStatsList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return SliverList.separated(
      itemCount: AppStrings.marketStats.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Row(
            children: [
              Text(AppStrings.marketStats[index].keys.join('').toString(),
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
            AppStrings.marketStats[index].values.join('').toString(),
            style: theme.textTheme.titleMedium
                ?.copyWith(fontSize: 12.sp, color: isDark ? AppColors.textWhite : AppColors.primary),
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
