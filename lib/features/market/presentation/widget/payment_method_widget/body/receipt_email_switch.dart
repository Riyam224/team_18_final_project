import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class ReceiptEmailSwitch extends StatefulWidget {
  const ReceiptEmailSwitch({super.key});

  @override
  State<ReceiptEmailSwitch> createState() => _ReceiptEmailSwitchState();
}

class _ReceiptEmailSwitchState extends State<ReceiptEmailSwitch> {
  bool vlaue = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 45).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.sendReceiptToYourEmail,
            style: context.appTheme.textTheme.headlineSmall!.copyWith(
                fontSize: 12.sp,
                color: context.islight()
                    ? AppColors.primary
                    : AppColors.textWhite),
          ),
          Switch(
            focusColor: Colors.amber,
            inactiveTrackColor: AppColors.gray3,

            inactiveThumbColor: AppColors.darkBackground,
            activeThumbColor:
                context.isDark() ? AppColors.darkBackground : AppColors.primary,
            activeTrackColor:
                context.isDark() ? AppColors.lightSurface : AppColors.primary,
            value: vlaue,
            onChanged: (value) {
              setState(() {
                this.vlaue = value;
              });
            },
            mouseCursor: SystemMouseCursors.click,
            trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.transparent; // or your ON state color
                }
                return Colors.transparent; // or your OFF state color
              },
            ),
            //  trackRadius: BorderRadius.circular(24),
            thumbIcon: MaterialStateProperty.resolveWith<Icon>(
              (states) {
                if (states.contains(MaterialState.selected)) {
                  print("object");
                  // ON state icon
                  return Icon(Icons.circle,
                      color: context.isDark()
                          ? AppColors.darkBackground
                          : AppColors.lightSurface,
                      size: 30);
                }
                // OFF state icon
                return Icon(Icons.circle,
                    color: context.isDark()
                        ? AppColors.darkBackground
                        : AppColors.lightSurface,
                    size: 30);
              },
            ),
          )
        ],
      ),
    );
  }
}
