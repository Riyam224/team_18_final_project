import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class CircleButton extends StatelessWidget {
  final Widget icon;
  final double? size;
  final VoidCallback onPressed;
  final Color? color;
  final Color? iconColor;

  const CircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 55.w;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: color ?? AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: IconTheme(
            data: IconThemeData(color: iconColor ?? Colors.white),
            child: icon,
          ),
        ),
      ),
    );
  }
}
