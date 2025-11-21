import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class CryptoItemTile extends StatelessWidget {
  final String name;
  final String symbol;
  final String price;
  final String percentage;
  final Color iconColor;

  const CryptoItemTile({
    super.key,
    required this.name,
    required this.symbol,
    required this.price,
    required this.percentage,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNegative = percentage.contains('-');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ========= TOP ROW (Icon + Name/Symbol) =========
          Row(
            children: [
              // Icon circle
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor.withOpacity(0.15),
                ),
                child: Icon(Icons.currency_bitcoin, color: iconColor, size: 22),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    symbol,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: theme.textTheme.bodySmall!.color!.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ========= PRICE & PERCENTAGE =========
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// PRICE
              Text(
                price,
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              /// PERCENTAGE
              Row(
                children: [
                  Text(
                    percentage,
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isNegative
                          ? AppColors.priceDown
                          : AppColors.priceUp,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_up,
                    size: 18,
                    color: isNegative
                        ? AppColors.priceDown
                        : AppColors.priceUp,
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
