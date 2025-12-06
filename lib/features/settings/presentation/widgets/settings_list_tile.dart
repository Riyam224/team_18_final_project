import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsListTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool hasChevron;
  final bool showDivider;
  final TextStyle? titleTextStyle;
  final Color? dividerColor;
  final Color? chevronColor;
  final String? chevronPath;
  const SettingsListTile({
    super.key,
    required this.title,
    required this.iconPath,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.hasChevron = true,
    this.showDivider = true,
    this.titleTextStyle,
    this.dividerColor,
    this.chevronColor,
    this.chevronPath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color iconBackgroundColor =
        isDark ? AppColors.iconDark : theme.primaryColor;
    final Color iconForegroundColor = AppColors.textWhite;

    final defaultTextColor = isDark
        ? theme.textTheme.titleMedium!.color
        : theme.textTheme.titleMedium!.color;

    final Color fixedDividerColor = AppColors.grayDevider;

    final Color finalDividerColor = dividerColor ?? fixedDividerColor;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            color: theme.scaffoldBackgroundColor,
            height: AppSizing.h72,
            padding: AppSpacing.paddingV20,
            child: Row(
              children: [
                Container(
                  width: AppSizing.w32,
                  height: AppSizing.h32,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      width: AppSizing.w18,
                      height: AppSizing.w18,
                      colorFilter: ColorFilter.mode(
                        iconForegroundColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                AppSpacing.gapW16,

                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium!
                        .copyWith(
                          color: defaultTextColor,
                          fontWeight: FontWeight.w500,
                        )
                        .merge(titleTextStyle),
                  ),
                ),

                if (trailing != null) trailing!,

                if (trailing == null && hasChevron)
                  Builder(builder: (context) {
                    final TextDirection textDirection =
                        Directionality.of(context);
                    final bool isRTL = textDirection == TextDirection.rtl;

                    final Color finalChevronColor = chevronColor ??
                        (isDark ? AppColors.textWhite : theme.primaryColor);

                    final Widget chevronWidget;

                    if (chevronPath != null) {
                      chevronWidget = SvgPicture.asset(
                        chevronPath!,
                        width: AppSizing.w20,
                        height: AppSizing.w20,
                        colorFilter: ColorFilter.mode(
                          finalChevronColor,
                          BlendMode.srcIn,
                        ),
                      );
                    } else {
                      chevronWidget = Icon(
                        Icons.keyboard_arrow_right,
                        size: AppSizing.w24,
                        color: finalChevronColor,
                      );
                    }

                    return RotatedBox(
                      quarterTurns: isRTL ? 2 : 0,
                      child: chevronWidget,
                    );
                  }),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 0, thickness: 1.0, color: finalDividerColor),
      ],
    );
  }
}
