import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class FeeAndAmountRow extends StatelessWidget {
  const FeeAndAmountRow({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSpacing.vertical(
      75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 217.w,
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12)
                    .r,
            decoration: BoxDecoration(
              color: context.isDark()
                  ? AppColors.darkBackground
                  : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(8).r),
                        child: Center(
                          child: AppSvgWidget(
                            color: context.isDark()
                                ? AppColors.darkBackground
                                : AppColors.lightSurface,
                            boxFit: BoxFit.fill,
                            assetsName: AppAssets.money,
                            height: 25.h,
                            width: 25.w,
                          ),
                        )),
                    AppSpacing.horizontal(16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.exchangeFee,
                          style: context.appTheme.textTheme.titleMedium
                              ?.copyWith(
                                  fontSize: 12.sp, color: AppColors.gray1),
                        ),
                        Text(
                          AppStrings.feePercentageText,
                          style: context.appTheme.textTheme.titleSmall
                              ?.copyWith(
                                  fontSize: 16.sp,
                                  color: context.isDark()
                                      ? AppColors.textWhite
                                      : AppColors.primary),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 96.w,
            padding: EdgeInsets.all(8).r,
            decoration: BoxDecoration(
              color: context.isDark()
                  ? AppColors.darkBackground
                  : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(AppStrings.exchangeAmount,
                  style: context.appTheme.textTheme.headlineLarge?.copyWith(
                      fontSize: 20.sp,
                      color: context.isDark()
                          ? AppColors.textWhite
                          : AppColors.primary)),
            ),
          ),
        ],
      ),
    );
  }
}
