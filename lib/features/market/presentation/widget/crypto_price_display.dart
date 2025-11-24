import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              '\$54,382.64',
              style: TextStyle(
                color: context.isDark()
                    ? AppColors.textLightGreen
                    : AppColors.textBlack,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text('/ 1 BTC',
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
        style: Theme.of(context).textButtonTheme.style?.copyWith(
            padding: WidgetStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 8, vertical: 8).r),
            textStyle: WidgetStateProperty.all<TextStyle>(
                TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Lato'))),
        child: Row(
          children: [
            const Icon(Icons.arrow_outward_rounded),
            SizedBox(
              width: 4.w,
            ),
            const Text(
              '15.3%',
            ),
          ],
        ));
  }
}
