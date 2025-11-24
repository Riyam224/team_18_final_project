import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      child: Stack(
        children: [
          /// === TOP RIGHT ECLIPSE IMAGE ===
          Positioned(
            right: -66.w, // ⬅️ matches Figma bubble offset
            top: -90.h,
            child: Image.asset(
              isDark ? AppAssets.authEclipsDark : AppAssets.authEclipsLight,
              width: 342.w,
              height: 342.h,
              fit: BoxFit.cover,
            ),
          ),

          /// Screen content
          child,
        ],
      ),
    );
  }
}
