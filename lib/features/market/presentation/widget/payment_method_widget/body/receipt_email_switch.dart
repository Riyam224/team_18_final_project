import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
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
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    return Padding(
      padding: AppSpacing.paddingH16V45,
      // const EdgeInsets.symmetric(horizontal: 16, vertical: 45).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.sendReceiptToYourEmail,
            style: _theme.textTheme.headlineSmall!.copyWith(
                fontSize: 12.sp,
                color: _isDark ? AppColors.textWhite : AppColors.primary),
          ),
          Switch(
            focusColor: Colors.amber,
            inactiveTrackColor: AppColors.gray3,
            inactiveThumbColor: AppColors.darkBackground,
            activeThumbColor:
                _isDark ? AppColors.darkBackground : AppColors.primary,
            activeTrackColor:
                _isDark ? AppColors.lightSurface : AppColors.primary,
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
                  return Colors.transparent;
                }
                return Colors.transparent;
              },
            ),
            thumbIcon: MaterialStateProperty.resolveWith<Icon>(
              (states) {
                if (states.contains(MaterialState.selected)) {
                  return Icon(Icons.circle,
                      color: _isDark
                          ? AppColors.darkBackground
                          : AppColors.lightSurface,
                      size: 30);
                }

                return Icon(Icons.circle,
                    color: _isDark
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
