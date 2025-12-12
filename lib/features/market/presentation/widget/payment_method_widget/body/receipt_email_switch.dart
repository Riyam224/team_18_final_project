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
  bool isSendReceiptEnabled = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: AppSpacing.paddingH16V45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.sendReceiptToYourEmail,
            style: theme.textTheme.headlineSmall!.copyWith(
                fontSize: 12.sp,
                color: isDark ? AppColors.textWhite : AppColors.primary),
          ),
          Switch(
            focusColor: Colors.amber,
            inactiveTrackColor: AppColors.gray3,
            inactiveThumbColor: AppColors.darkBackground,
            activeThumbColor:
                isDark ? AppColors.darkBackground : AppColors.primary,
            activeTrackColor:
                isDark ? AppColors.lightSurface : AppColors.primary,
            value: isSendReceiptEnabled,
            onChanged: (value) {
              setState(() {
                isSendReceiptEnabled = value;
              });
            },
            mouseCursor: SystemMouseCursors.click,
            trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.transparent;
                }
                return Colors.transparent;
              },
            ),
            thumbIcon: WidgetStateProperty.resolveWith<Icon>(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return Icon(Icons.circle,
                      color: isDark
                          ? AppColors.darkBackground
                          : AppColors.lightSurface,
                      size: 30);
                }

                return Icon(Icons.circle,
                    color: isDark
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
