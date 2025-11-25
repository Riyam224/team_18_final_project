import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class CryptoPriceDisplay extends StatelessWidget {
  const CryptoPriceDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.priceDisplay,
              style: TextStyle(
                color: context.isDark()
                    ? AppColors.textLightGreen
                    : AppColors.textBlack,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(AppStrings.btc,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: AppColors.gray2)),
          ],
        ),
        investmentGrowthButton(context)
      ],
    );
  }

  TextButton investmentGrowthButton(BuildContext context) {
    return TextButton(
        onPressed: () {},
        style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8.r))),
            backgroundColor: WidgetStateProperty.all(
                context.isDark() ? AppColors.lightSurface : AppColors.primary),
            padding: WidgetStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 8, vertical: 8).r),
            minimumSize: WidgetStateProperty.all<Size>(Size(70.w, 32.h)),
            textStyle: WidgetStateProperty.all<TextStyle>(
                TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Lato'))),
        child: Row(
          children: [
            Icon(Icons.arrow_outward_rounded,
                fontWeight: FontWeight.w700,
                color: context.isDark()
                    ? AppColors.darkBackground
                    : AppColors.lightSurface),
            AppSpacing.horizontal(4),
            Text(AppStrings.percentage,
                style: context.appTheme.textTheme.labelLarge?.copyWith(
                    fontSize: 12.sp,
                    color: context.isDark()
                        ? AppColors.darkBackground
                        : AppColors.lightSurface)),
          ],
        ));
  }
}
