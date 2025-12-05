import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            height: 72.h,
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20.h),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      width: 18.w,
                      height: 18.w,
                      colorFilter: ColorFilter.mode(
                        iconForegroundColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // العنوان
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
                        width: 20.w,
                        height: 20.w,
                        colorFilter: ColorFilter.mode(
                          finalChevronColor,
                          BlendMode.srcIn,
                        ),
                      );
                    } else {
                      chevronWidget = Icon(
                        Icons.keyboard_arrow_right,
                        size: 24.w,
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
