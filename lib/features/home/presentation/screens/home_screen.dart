import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
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
    return const HomeScreenContent();
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

  late final ISecureStorage _secureStorage;

  @override
  void initState() {
    super.initState();
    _secureStorage = sl<ISecureStorage>();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      // Load user first name
      final firstNameResult = await _secureStorage.read(
        key: StorageKeysConfig.userDisplayName,
      );
      final firstName = firstNameResult.fold(
        (failure) => null,
        (value) => value,
      );

      // Fallback to email username if no stored display name
      final emailResult = await _secureStorage.read(
        key: StorageKeysConfig.userEmail,
      );
      final email = emailResult.fold(
        (failure) => null,
        (value) => value,
      );

      // Load avatar path
      final avatarResult = await _secureStorage.read(
        key: StorageKeysConfig.avatarUrl,
      );
      final avatarPath = avatarResult.fold(
        (failure) => null,
        (value) => value,
      );

      if (!mounted) return;

      setState(() {
        _userName =
            _extractFirstName(firstName) ?? _extractFirstName(email) ?? _userName;
        _avatarPath = avatarPath;
      });
    } catch (e) {
      // Silently handle any errors and keep default values
      debugPrint('Error loading user profile: $e');
    }
  }

  String? _extractFirstName(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;

    // If value looks like an email, use the part before @
    final emailSplit = trimmed.split('@');
    final base = emailSplit.first;

    final parts = base.split(RegExp(r'\s+'));
    final first = parts.first;
    if (first.isEmpty) return null;
    return first;
  }

  @override
  void dispose() {
    // Clean up resources if needed
    super.dispose();
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
                onRefresh: () async {
                  try {
                    await context.read<HomeCubit>().refreshHomeData();
                  } catch (e) {
                    debugPrint('Error refreshing home data: $e');
                  }
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AppSpacing.paddingH16V8,
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
                        const Expanded(
                          child: SectionTitle(
                            title: "Trending Now",
                          ),
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
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
