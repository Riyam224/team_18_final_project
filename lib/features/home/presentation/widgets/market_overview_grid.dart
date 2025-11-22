import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                height: 110.h,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildCard(
                context: context,
                theme: theme,
                title: items[1]["title"]!,
                value: items[1]["value"]!,
                showPercent: true,
                height: 110.h,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
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
                height: 85.h,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildCard(
                context: context,
                theme: theme,
                title: items[3]["title"]!,
                value: items[3]["value"]!,
                showPercent: false,
                height: 85.h,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
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
          if (showPercent) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Text(
                  "2.35% ",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.marketValue.withOpacity(0.85),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "▲",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.accentBlue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(height: 6.h),
          ],
        ],
      ),
    );
  }
}
