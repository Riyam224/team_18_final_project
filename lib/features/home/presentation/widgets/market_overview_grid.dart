import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/home/domain/entities/market_overview.dart';

class MarketOverviewGrid extends StatelessWidget {
  final MarketOverview marketOverview;

  const MarketOverviewGrid({super.key, required this.marketOverview});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, String>> items = [
      {"title": "Market Cap", "value": marketOverview.marketCap},
      {"title": "24h Volume", "value": marketOverview.volume24h},
      {"title": "BTC Dominance", "value": marketOverview.btcDominance},
      {"title": "Active Coins", "value": marketOverview.activeCoins.toString()},
    ];

    return Column(
      children: [
        // Top row (Market Cap & 24h Volume)
        Row(
          children: [
            Expanded(
              child: _buildCard(
                context: context,
                theme: theme,
                title: items[0]["title"]!,
                value: items[0]["value"]!,
                showPercent: true,
                height: AppSizing.h110,
              ),
            ),
            AppSpacing.gapW12,
            Expanded(
              child: _buildCard(
                context: context,
                theme: theme,
                title: items[1]["title"]!,
                value: items[1]["value"]!,
                showPercent: true,
                height: AppSizing.h110,
              ),
            ),
          ],
        ),
        AppSpacing.gapH12,
        // Bottom row (BTC Dominance & Active Coins)
        Row(
          children: [
            Expanded(
              child: _buildCard(
                context: context,
                theme: theme,
                title: items[2]["title"]!,
                value: items[2]["value"]!,
                showPercent: false,
                height: AppSizing.h85,
              ),
            ),
            AppSpacing.gapW12,
            Expanded(
              child: _buildCard(
                context: context,
                theme: theme,
                title: items[3]["title"]!,
                value: items[3]["value"]!,
                showPercent: false,
                height: AppSizing.h85,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required ThemeData theme,
    required String title,
    required String value,
    required bool showPercent,
    required double height,
  }) {
    return Container(
      height: height,
      padding: AppSpacing.paddingH16V14,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizing.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            title,
            style: theme.textTheme.titleSmall!.copyWith(
              color: theme.brightness == Brightness.dark
                  ? AppColors.lightSurface
                  : AppColors.marketItem,
              height: 1.43,
            ),
          ),

          const Spacer(),

          /// VALUE
          Text(
            value,
            style: theme.textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.brightness == Brightness.dark
                  ? AppColors.lightSurface
                  : AppColors.marketItem,
            ),
          ),

          /// % For top two only
          AppSpacing.gapH8,
          if (showPercent) ...[
            Row(
              children: [
                Text(
                  "${marketOverview.marketCapChangePercentage.toStringAsFixed(2)}% ",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: marketOverview.marketCapChangePercentage >= 0
                        ? AppColors.accentBlue
                        : AppColors.priceDown,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  marketOverview.marketCapChangePercentage >= 0 ? "▲" : "▼",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: marketOverview.marketCapChangePercentage >= 0
                        ? AppColors.accentBlue
                        : AppColors.priceDown,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
