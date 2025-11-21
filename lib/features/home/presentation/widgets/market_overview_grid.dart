import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

class MarketOverviewGrid extends StatelessWidget {
  const MarketOverviewGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, String>> items = [
      {"title": "Market Cap", "value": "\$2.1T"},
      {"title": "24h Volume", "value": "\$85.5B"},
      {"title": "BTC Dominance", "value": "48.5%"},
      {"title": "Active Coins", "value": "19,417"},
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
                style: theme.textTheme.titleSmall!.copyWith(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.lightSurface
                      : AppColors.marketItem,
                  height: 1.43,
                ),
              ),
              const Spacer(),
              Text(
                items[i]["value"]!,
                style: theme.textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.brightness == Brightness.dark
                      ? AppColors.lightSurface
                      : AppColors.marketItem,
                  height: 1,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text("2.35% ",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.marketValue.withOpacity(0.85),
                        height: 1.33,
                        fontWeight: FontWeight.w700,
                      )),
                  Text(
                    "▲",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accentBlue,
                      height: 1.33,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
