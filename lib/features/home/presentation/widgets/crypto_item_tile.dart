import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class CryptoItemTile extends StatelessWidget {
  final String name;
  final String symbol;
  final String price;
  final String percentage;
  final Color? iconColor;

  const CryptoItemTile({
    super.key,
    required this.name,
    required this.symbol,
    required this.price,
    required this.percentage,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNegative = percentage.contains('-');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: iconColor?.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.currency_bitcoin, color: iconColor, size: 20),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: theme.textTheme.titleMedium),
                  Text(symbol, style: theme.textTheme.bodySmall),
                ],
              )
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price, style: theme.textTheme.titleLarge),
              Text(
                "$percentage ▲",
                style: theme.textTheme.bodySmall!.copyWith(
                  color: isNegative ? AppColors.priceDown : AppColors.priceUp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
