import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/common_ui/widgets/bottom_action_button.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class PaymentActionButton extends StatelessWidget {
  const PaymentActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 23).r,
      child: BottomActionButton.text(
        backgroundColor:
            context.islight() ? AppColors.primary : AppColors.lightSurface,
        height: 52.h,
        borderRadiusGeometry: BorderRadius.circular(31).r,
        onPressed: () {},
        text: AppStrings.buy,
        fontSize: 16.sp,
        textColor: context.islight() ? AppColors.textWhite : AppColors.textDark,
      ),
    );
  }
}
