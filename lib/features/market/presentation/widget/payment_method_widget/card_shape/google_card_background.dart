import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';

class GoogleCardBackground extends StatelessWidget {
  final Widget creditCardContent;
  const GoogleCardBackground({super.key, required this.creditCardContent});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        left: -6,
        top: 70,
        child: CustomPaint(
          child: Image.asset(
            AppAssets.googlePayLogo,
            fit: BoxFit.cover,
            scale: 1.6,
          ),
        ),
      ),
      Padding(
          padding: AppSpacing.paddingL23R23T15B15, child: creditCardContent),
    ]);
  }
}
