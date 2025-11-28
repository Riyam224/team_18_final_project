import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/bottom_action_button.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class ConfirmBuyButton extends StatelessWidget {
  const ConfirmBuyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomActionButton.text(
        backgroundColor:
            context.isDark() ? AppColors.lightSurface : AppColors.primary,
        textColor: context.isDark() ? AppColors.textDark : AppColors.textWhite,
        fontSize: 15.sp,
        borderRadiusGeometry: BorderRadius.circular(31),
        height: 45.h,
        text: AppStrings.buttonBuyCrypto,
        onPressed: () {});

    //  BottomActionButton(
    //   backgroundColor:
    //       context.isDark() ? AppColors.lightSurface : AppColors.primary,
    //   textColor: context.isDark() ? AppColors.textDark : AppColors.textWhite,
    //   height: 45.h,
    //   borderRadiusGeometry: BorderRadius.circular(31),
    //   text: AppStrings.buttonBuyCrypto,
    //   child: Text(
    //     AppStrings.buttonBuyCrypto,
    //     style: context.appTheme.textTheme.headlineLarge?.copyWith(
    //         color: context.isDark() ? AppColors.textDark : AppColors.textWhite,
    //         fontSize: 15.sp),
    //   ),
    //   onPressed: () {},
    // );
  }
}
