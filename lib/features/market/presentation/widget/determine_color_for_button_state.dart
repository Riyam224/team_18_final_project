import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class DetermineColorForButtonState extends StatelessWidget { 
  final Function(String period) onPeriodSelected;
  final String selectedPeriod;

  const DetermineColorForButtonState({
    super.key,
    required this.onPeriodSelected,
    required this.selectedPeriod,
  });

  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final currentPeriod = selectedPeriod; 

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(AppStrings.items.length, (int index) {
        final period = AppStrings.items[index];
        final isSelected = period == currentPeriod; 

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: TextButton(
            onPressed: () {
              onPeriodSelected(period);
            },
            style: ButtonStyle(
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
              minimumSize: WidgetStateProperty.all(Size(50.w, 32.h)),
              backgroundColor: WidgetStateProperty.all<Color>(isDark
                  ? isSelected
                      ? AppColors.lightSurface
                      : AppColors.darkBackground
                  : isSelected
                      ? AppColors.primary
                      : AppColors.lightSurface),
            ),
            child: Text(period,
                style: theme.textTheme.labelMedium!.copyWith(
                    color: isSelected
                        ? (isDark
                            ? AppColors.textDark
                            : AppColors.textWhite)
                        : AppColors.textGray)),
          ),
        );
      }),
    );
  }
}