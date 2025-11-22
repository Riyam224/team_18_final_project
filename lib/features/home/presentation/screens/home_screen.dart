import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:team_18_final_project/features/home/presentation/widgets/view_all.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              SizedBox(height: 16.h),
              const BalanceCard(),
              SizedBox(height: 24.h),
              const SectionTitle(title: "Market Overview"),
              SizedBox(height: 12.h),
              const MarketOverviewGrid(),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionTitle(
                    title: "Trending Now",
                  ),
                  const ViewAll(
                    title: "view all",
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              const TrendingNowList(),
              SizedBox(height: 24.h),
              const SectionTitle(title: "Top Gainers"),
              SizedBox(height: 12.h),
              const TopGainersList(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
