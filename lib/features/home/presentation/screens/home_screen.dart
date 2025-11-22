import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/features/home/presentation/cubit/home_cubit.dart';
import 'package:team_18_final_project/features/home/presentation/cubit/home_state.dart';
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
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..loadHomeData(),
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeCubit>().refreshHomeData();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().refreshHomeData(),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeHeader(),
                      SizedBox(height: 16.h),
                      BalanceCard(
                        totalBalance: state.portfolioBalance.totalBalance,
                        weeklyChangePercentage:
                            state.portfolioBalance.weeklyChangePercentage,
                      ),
                      SizedBox(height: 24.h),
                      const SectionTitle(title: "Market Overview"),
                      SizedBox(height: 12.h),
                      MarketOverviewGrid(marketOverview: state.marketOverview),
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
                      TrendingNowList(trendingCoins: state.trendingCoins),
                      SizedBox(height: 24.h),
                      const SectionTitle(title: "Top Gainers"),
                      SizedBox(height: 12.h),
                      TopGainersList(topGainers: state.topGainers),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
