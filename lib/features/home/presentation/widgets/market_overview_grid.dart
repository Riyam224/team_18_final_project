import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';

class MarketOverviewGrid extends StatelessWidget {
  const MarketOverviewGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, String>> items = [
      {"title": AppStrings.marketCap, "value": "\$2.1T"},
      {"title": AppStrings.volume24h, "value": "\$85.5B"},
      {"title": AppStrings.btcDominance, "value": "48.5%"},
      {"title": AppStrings.activeCoins, "value": "19,417"},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 110,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                items[i]["title"]!,
                style: theme.textTheme.bodyMedium,
              ),
              const Spacer(),
              Text(
                items[i]["value"]!,
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "2.35% ▲",
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.primary,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
