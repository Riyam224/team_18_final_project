import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String valueChange;
  final bool isBuy;

  const TransactionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.valueChange,
    required this.isBuy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = isBuy ? AppColors.priceUp : AppColors.alertRed;
    final icon = isBuy ? Icons.arrow_upward : Icons.arrow_downward;
    final cardColor = isDark ? const Color(0xFF0D0D0D) : Colors.white;
    final textColor = isDark ? AppColors.textWhite : AppColors.textGray;
    final subColor = isDark ? AppColors.textGrayLight : AppColors.gray3;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.25)
        : Colors.black.withOpacity(0.04);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: iconColor.withOpacity(0.4)),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? textColor : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: subColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textGray,
                ),
              ),
              Text(
                valueChange,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isBuy ? AppColors.priceUp : AppColors.alertRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
