import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: AppSizing.textFieldHeight,
      padding: AppSpacing.textFieldPadding,
      decoration: ShapeDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightInputBackground,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: AppSizing.borderThin,
            color: isDark ? AppColors.textWhite : AppColors.primary,
          ),
          borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
        ),
        shadows: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: AppSizing.shadowBlurRadius,
            offset: Offset(0, AppSizing.shadowOffsetY),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSizing.iconSmall,
            color: isDark
                ? AppColors.textWhiteSoft
                : AppColors.gray2,
          ),
          AppSpacing.hSpace16,
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: AppTextStyles.authTextFieldInput.copyWith(
                fontSize: 14.sp,
                color: isDark ? AppColors.textWhite : AppColors.textDark,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppTextStyles.authTextFieldHint.copyWith(
                  fontSize: 14.sp,
                  color: isDark
                      ? AppColors.textGrayDark
                      : AppColors.gray3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
