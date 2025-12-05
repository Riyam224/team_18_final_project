import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class CustomToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final double width = 39.w; 
    final double height = 24.h;
    final double toggleDiameter = 20.h;

    final Color activeColor =  AppColors.iconDark ;
    final Color inactiveColor =  AppColors.primary ;

    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
        width: width,
        height: height,
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: value ? activeColor : inactiveColor,
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: toggleDiameter,
          height: toggleDiameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.textWhite,
          ),
        ),
      ),
    );
  }
}