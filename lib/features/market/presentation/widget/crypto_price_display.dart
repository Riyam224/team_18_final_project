import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class CryptoPriceDisplay extends StatelessWidget {
  const CryptoPriceDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
                color: isDark ? AppColors.textLightGreen : AppColors.textBlack,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(AppStrings.btc,
                style:
                    theme.textTheme.labelLarge!.copyWith(color: AppColors.gray2)),
          ],
        ),
        investmentGrowthButton(context)
      ],
    );
  }

  TextButton investmentGrowthButton(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return TextButton(
        onPressed: () {},
        style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8.r))),
            backgroundColor:
                WidgetStateProperty.all(isDark ? AppColors.lightSurface : AppColors.primary),
            padding: WidgetStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 8, vertical: 8).r),
            minimumSize: WidgetStateProperty.all<Size>(Size(70.w, 32.h)),
            textStyle: WidgetStateProperty.all<TextStyle>(
                TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Lato'))),
        child: Row(
          children: [
            Icon(Icons.arrow_outward_rounded,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkBackground : AppColors.lightSurface),
            AppSpacing.horizontal(4),
            Text(AppStrings.percentage,
                style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 12.sp,
                    color: isDark ? AppColors.darkBackground : AppColors.lightSurface)),
          ],
        ));
  }
}
