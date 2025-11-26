import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class BitcoinTitleDescription extends StatelessWidget {
  const BitcoinTitleDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(left: 2).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.aboutBitcoin,
              style: context.appTheme.textTheme.titleSmall!.copyWith(
                  fontSize: 18.sp,
                  color: context.isDark()
                      ? AppColors.textWhite
                      : AppColors.primary)),
          AppSpacing.vertical(22),
          Text(
            textAlign: TextAlign.left,
            AppStrings.bitcoinDescription,
            style: context.appTheme.textTheme.bodyLarge!.copyWith(
              fontSize: 13.sp,
              color: context.isDark() ? AppColors.textWhite : AppColors.gray2,
            ),
          ),
        ],
      ),
    ));
  }
}
