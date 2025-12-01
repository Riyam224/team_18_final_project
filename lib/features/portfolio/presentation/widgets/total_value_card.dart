import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';

class TotalValueCard extends StatelessWidget {
  final String title;
  final String value;
  final String changeLabel;
  final Color changeColor;

  const TotalValueCard({
    super.key,
    required this.title,
    required this.value,
    required this.changeLabel,
    this.changeColor = AppColors.priceUp,
  });

  @override
  Widget build(BuildContext context) {
    // Use primary color for both light and dark themes
    const bgColor = AppColors.primary;
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingAll20,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizing.radius20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          AppSpacing.gapH8,
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              color: Colors.white,
            ),
          ),
          AppSpacing.gapH8,
          Text(
            changeLabel,
            style: AppTextStyles.bodyMedium.copyWith(
              color: changeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
