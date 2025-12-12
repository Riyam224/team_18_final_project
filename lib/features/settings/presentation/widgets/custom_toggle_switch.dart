import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
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
    
    final double width = AppSizing.w39; 
    final double height = AppSizing.h24;
    final double toggleDiameter = AppSizing.h20;

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
        padding: AppSpacing.paddingAllH2,
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