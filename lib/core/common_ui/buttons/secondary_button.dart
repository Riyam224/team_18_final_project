import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? height;
  final double? radius;
  final Color? borderColor;
  final Color? textColor;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.radius,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    /// Theme-based colors (unless user overrides)
    final Color effectiveBorderColor =
        borderColor ?? (isDark ? AppColors.textWhite : AppColors.primary);

    final Color effectiveTextColor =
        textColor ?? (isDark ? AppColors.textWhite : AppColors.primary);

    final buttonHeight = height ?? 55.h;
    final buttonRadius = radius ?? 40.r;

    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: effectiveBorderColor,
            width: 1.6.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.bodyLarge.copyWith(
            color: effectiveTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
