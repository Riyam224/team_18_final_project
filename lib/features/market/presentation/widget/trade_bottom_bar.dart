import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/bottom_action_button.dart';
import 'package:team_18_final_project/core/constants/theme_mode_color.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class TradeBottomBar extends StatelessWidget {
  const TradeBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 62.h,
      color: ThemeModeColor.checkColorDarkOrLight(context,
          colorDark: AppColors.darkBackground,
          colorLight: AppColors.lightSurface),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomActionButton(
            textColor: ThemeModeColor.checkColorDarkOrLight(context,
                colorDark: AppColors.error, colorLight: AppColors.alertRed),
            width: 125.w,
            height: 40.h,
            backgroundColor: ThemeModeColor.checkColorDarkOrLight(context,
                colorDark: AppColors.darkBrown,
                colorLight: AppColors.lightPink),
            borderRadiusGeometry: BorderRadius.circular(31),
            text: 'Sell',
            onPressed: () {},
          ),
          BottomActionButton(
            textColor: ThemeModeColor.checkColorDarkOrLight(context,
                colorDark: AppColors.darkBackground,
                colorLight: AppColors.textWhite),
            width: 125.w,
            height: 40.h,
            backgroundColor: ThemeModeColor.checkColorDarkOrLight(context,
                colorDark: AppColors.lightSurface,
                colorLight: AppColors.primary),
            borderRadiusGeometry: BorderRadius.circular(31),
            text: 'Buy',
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
