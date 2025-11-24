import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class MarketStatsList extends StatelessWidget {
  final List<Map<String, String>> stats = [
    {'Current Price': '44,826.12 \$'},
    {'Market Cap': '836,819 \$'},
    {'Volume 24h': '35,867 \$'},
    {'Available Supply': '18,784'},
    {'Max Supply': '21,000'},
  ];

  MarketStatsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: stats.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Row(
              children: [
                Text(stats[index].keys.join('').toString(),
                    style: context.appTheme.textTheme.titleLarge!.copyWith(
                      fontSize: 12.sp,
                    )),
                SizedBox(width: 16.w),
                AppSvgWidget(
                  height: 12.h,
                  width: 12.w,
                  assetsName: 'assets/svg/info_outline.svg',
                )
              ],
            ),
            trailing: Text(stats[index].values.join('').toString(),
                style: context.appTheme.textTheme.titleSmall!));
      },
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsetsDirectional.only(start: 15.r, end: 15.r),
          child: Divider(color: AppColors.gray4, height: 1),
        );
      },
    );
  }
}
