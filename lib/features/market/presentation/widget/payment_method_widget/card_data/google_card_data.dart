import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class GoogleCardData extends StatelessWidget {
  const GoogleCardData({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppSvgWidget(
              assetsName: AppAssets.googleLogo,
            ),
            AppSpacing.horizontal(2),
            Text(AppStrings.play,
                style: _theme.textTheme.headlineLarge
                    ?.copyWith(color: AppColors.gray2, fontSize: 22.sp))
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 22, bottom: 5).r,
                  child: Text(AppStrings.dEBIT,
                      style: _theme.textTheme.labelLarge
                          ?.copyWith(color: AppColors.gray2)),
                ),
                AppSvgWidget(
                  assetsName: AppAssets.visaLogo,
                  color: AppColors.primary,
                  width: 20.w,
                  height: 20.h,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
