import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/security/secure_storage_service.dart';
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

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  String _userName = 'User';
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final firstName = await SecureStorageService.getUserFirstName();
    final avatarPath = await SecureStorageService.getAvatarPath();

    if (!mounted) return;

    setState(() {
      if (firstName != null && firstName.isNotEmpty) {
        _userName = firstName;
      }
      _avatarPath = avatarPath;
    });
  }

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
                    AppSpacing.gapH16,
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeCubit>().refreshHomeData();
                      },
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                ),
              );
            }

            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().refreshHomeData(),
                child: SingleChildScrollView(
                  padding: AppSpacing.paddingH16V8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeader(
                        userName: _userName,
                        avatarPath: _avatarPath,
                      ),
                      AppSpacing.gapH16,
                      BalanceCard(
                        totalBalance: state.portfolioBalance.totalBalance,
                        weeklyChangePercentage:
                            state.portfolioBalance.weeklyChangePercentage,
                      ),
                      AppSpacing.gapH24,
                      const SectionTitle(title: "Market Overview"),
                      AppSpacing.gapH12,
                      MarketOverviewGrid(marketOverview: state.marketOverview),
                      AppSpacing.gapH24,
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
                      AppSpacing.gapH12,
                      TrendingNowList(trendingCoins: state.trendingCoins),
                      AppSpacing.gapH24,
                      const SectionTitle(title: "Top Gainers"),
                      AppSpacing.gapH12,
                      TopGainersList(topGainers: state.topGainers),
                      AppSpacing.gapH24,
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
