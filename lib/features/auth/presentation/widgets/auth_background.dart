import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
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
            right: AppSizing.eclipseRight,
            top: AppSizing.eclipseTop,
            child: Image.asset(
              isDark ? AppAssets.authEclipsDark : AppAssets.authEclipsLight,
              width: AppSizing.w342,
              height: AppSizing.w342,
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
