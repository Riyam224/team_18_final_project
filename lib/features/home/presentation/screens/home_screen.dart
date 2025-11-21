import 'package:flutter/material.dart';
import '../widgets/balance_card.dart';
import '../widgets/home_header.dart';
import '../widgets/market_overview_grid.dart';
import '../widgets/section_title.dart';
import '../widgets/trending_now_list.dart';
import '../widgets/top_gainers_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(height: 16),

              const BalanceCard(),
              const SizedBox(height: 24),

              const SectionTitle(title: "Market Overview"),
              const SizedBox(height: 12),

              const MarketOverviewGrid(),
              const SizedBox(height: 24),

              const SectionTitle(
                title: "Trending Now",
                actionText: "View all",
              ),
              const SizedBox(height: 12),

              const TrendingNowList(),
              const SizedBox(height: 24),

              const SectionTitle(title: "Top Gainers"),
              const SizedBox(height: 12),

              const TopGainersList(),
            ],
          ),
        ),
      ),
    );
  }
}
