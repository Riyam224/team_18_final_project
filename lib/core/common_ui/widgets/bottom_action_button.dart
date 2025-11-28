import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class BottomActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final Widget? child;
  final BorderRadiusGeometry? borderRadiusGeometry;
  final EdgeInsetsGeometry? padding;

  const BottomActionButton({
    super.key,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
    this.borderRadiusGeometry,
    this.padding,
    this.child,
  });

  factory BottomActionButton.text({
    Key? key,
    required String text,
    Color? textColor,
    Color? backgroundColor,
    double? height,
    double? width,
    double? fontSize,
    BorderRadiusGeometry? borderRadiusGeometry,
    EdgeInsetsGeometry? padding,
    required VoidCallback? onPressed,
  }) {
    return BottomActionButton(
      key: key,
      textColor: textColor,
      height: height,
      width: width,
      borderRadiusGeometry: borderRadiusGeometry,
      padding: padding,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 75,
      width: width ?? double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: padding ?? EdgeInsets.all(8).r,
            backgroundColor: backgroundColor ?? AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadiusGeometry ??
                  const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
            ),
            elevation: 0,
          ),
          onPressed: onPressed,
          child: child),
    );
  }
}
