import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/bottom_action_button.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class ConfirmBuyButton extends StatelessWidget {
  const ConfirmBuyButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BottomActionButton.text(
        backgroundColor: isDark ? AppColors.lightSurface : AppColors.primary,
        textColor: isDark ? AppColors.textDark : AppColors.textWhite,
        fontSize: 15.sp,
        borderRadiusGeometry: BorderRadius.circular(31),
        height: 45.h,
        text: AppStrings.buttonBuyCrypto,
        onPressed: () {});
  }
}
