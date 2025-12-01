import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class HoldingCard extends StatelessWidget {
  final String name;
  final String symbol;
  final double percentage;
  final String amount;
  final String value;
  final String change;
  final String changePercent;
  final IconData icon;
  final Color iconColor;

  const HoldingCard({
    super.key,
    required this.name,
    required this.symbol,
    required this.percentage,
    required this.amount,
    required this.value,
    required this.change,
    required this.changePercent,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor =
        isDark ? const Color(0xFF0D0D0D) : Colors.white;
    final titleColor = isDark ? AppColors.textWhite : AppColors.textGray;
    final subtitleColor = isDark ? AppColors.textGrayLight : AppColors.gray3;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.25)
        : Colors.black.withOpacity(0.04);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isDark ? titleColor : AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        symbol,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amount,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: titleColor,
                    ),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    change,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.priceUp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    changePercent,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.priceUp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
