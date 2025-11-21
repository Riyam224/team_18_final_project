import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.primary : const Color(0xFF1D3A70),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Opacity(
              opacity: 0.70,
              child: Text('Current Balance',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: const Color(0xFFF5F8FE),
                    height: 2.02,
                    letterSpacing: 0.44,
                  )),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              "\$143,421.20",
              style: theme.textTheme.headlineMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                height: 1.01,
                letterSpacing: 0.99,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Weekly Profit",
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.cardWeekly,
                    fontWeight: FontWeight.w600, // SemiBold
                    height: 2.02,
                    letterSpacing: 0.44,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "2.35% ▲",
                    style: theme.textTheme.labelLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
