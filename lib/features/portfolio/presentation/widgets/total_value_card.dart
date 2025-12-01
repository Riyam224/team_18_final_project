import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0D0D0D) : const Color(0xFF1D3A70);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            changeLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: changeColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
