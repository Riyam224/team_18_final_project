import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import '../../config/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;
  final double? radius;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.radius,
    this.color,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? 55.h;
    final buttonRadius = radius ?? 40.r;

    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: borderColor ?? Colors.transparent, width: 1.6.w),
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.bodyLarge.copyWith(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
