import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditCardWidget extends StatelessWidget {
  final Widget creditCardBackground;
  final Color? colorBegin;
  final Color? colorEnd;
  final void Function() onTap;

  const CreditCardWidget({
    super.key,
    required this.creditCardBackground,
    this.colorBegin,
    this.colorEnd,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 24, left: 19, right: 19, bottom: 19).r,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(16.r),
              child: Container(
                  width: double.infinity,
                  height: 200.7.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        colorBegin ?? Colors.transparent,
                        colorEnd ?? Colors.transparent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: creditCardBackground),
            ),
          ),
        ],
      ),
    );
  }
}
