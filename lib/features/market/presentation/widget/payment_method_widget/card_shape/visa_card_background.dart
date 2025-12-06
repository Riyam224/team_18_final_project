import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';

class VisaCardBackground extends StatelessWidget {
  final Widget creditCardContent;
  const VisaCardBackground({super.key, required this.creditCardContent});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned(
          right: -10,
          top: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 150.w,
                height: 150.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.only(
                    topLeft: Radius.circular(250),
                  ),
                  color: _isDark
                      ? Color.fromARGB(221, 154, 76, 202).withOpacity(0.3)
                      : Color.fromARGB(221, 88, 44, 116).withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          top: 70,
          left: 0,
          child: Container(
            width: 150.w,
            height: 180.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusGeometry.only(
                topRight: Radius.circular(200),
              ),
              color: _isDark
                  ? Color.fromARGB(221, 154, 76, 202).withOpacity(0.3)
                  : Color.fromARGB(119, 2, 22, 94).withOpacity(0.2),
            ),
          ),
        ),
        Positioned(
          top: -30,
          right: -55,
          child: Container(
            width: 180.w,
            height: 180.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusGeometry.only(
                topLeft: Radius.circular(250),
                bottomLeft: Radius.circular(250),
                bottomRight: Radius.circular(250),
              ),
              color: _isDark
                  ? Color.fromARGB(255, 60, 29, 114).withOpacity(0.4)
                  : Color(0xFF7C3AED).withOpacity(0.2),
            ),
          ),
        ),
        // Card content
        Padding(
            padding: AppSpacing.paddingL23R23T15B15, child: creditCardContent),
      ],
    );
  }
}
