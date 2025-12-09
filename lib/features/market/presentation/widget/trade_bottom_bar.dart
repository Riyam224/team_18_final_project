import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/bottom_action_button.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class TradeBottomBar extends StatelessWidget {
  const TradeBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: 62.h,
      color: isDark ? AppColors.darkBackground : AppColors.lightSurface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomActionButton.text(
            textColor: AppColors.alertRed,
            width: 145.w,
            height: 45.h,
            backgroundColor: isDark ? AppColors.darkBrown : AppColors.lightPink,
            borderRadiusGeometry: BorderRadius.circular(31),
            text: AppStrings.sell,
            onPressed: () {},
          ),
          BottomActionButton.text(
            textColor: isDark ? AppColors.darkBackground : AppColors.textWhite,
            width: 145.w,
            height: 45.h,
            backgroundColor:
                isDark ? AppColors.lightSurface : AppColors.primary,
            borderRadiusGeometry: BorderRadius.circular(31),
            text: AppStrings.buy,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
