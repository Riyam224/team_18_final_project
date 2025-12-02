import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/custom_svg.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class VisaCardData extends StatelessWidget {
  const VisaCardData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppSvgWidget(
              assetsName: AppAssets.flashOn,
              width: 17.w,
              height: 17.h,
            ),
            AppSvgWidget(
              assetsName: AppAssets.contactless,
              width: 17.w,
              height: 17.h,
            )
          ],
        ),
        const Spacer(),
        Image.asset(
          AppAssets.eMVChip,
          width: 40.w,
          height: 35.h,
          color: Colors.amber,
        ),
        AppSpacing.vertical(5),
        Text(AppStrings.cardNumber,
            style: context.appTheme.textTheme.titleLarge?.copyWith(
                letterSpacing: 2,
                fontSize: 16.sp,
                color: context.islight()
                    ? AppColors.lightSurface2
                    : AppColors.lightSurface,
                fontWeight: FontWeight.w700)),
        AppSpacing.vertical(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.validTill,
                  style: context.appTheme.textTheme.titleMedium?.copyWith(
                      color:
                          context.isDark() ? AppColors.gray0 : AppColors.gray5,
                      fontSize: 8.sp),
                ),
                AppSpacing.vertical(2),
                Text(AppStrings.cardExpiry,
                    style: context.appTheme.textTheme.titleLarge?.copyWith(
                        fontSize: 10.sp,
                        color: context.islight()
                            ? AppColors.lightSurface2
                            : AppColors.lightSurface)),
              ],
            ),
          ],
        ),
        AppSpacing.vertical(11),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              AppStrings.cardHolderName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSvgWidget(
              assetsName: AppAssets.visaLogo,
              width: 10.w,
              height: 10.h,
            )
          ],
        ),
      ],
    );
  }
}
