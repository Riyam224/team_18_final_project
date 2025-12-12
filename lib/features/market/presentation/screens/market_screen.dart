import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_assets.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/market/presentation/cubit/market_cubit.dart';
import 'package:team_18_final_project/features/market/presentation/cubit/market_state.dart';
import 'package:team_18_final_project/features/market/presentation/widget/market_coin_tile.dart';
import 'package:team_18_final_project/features/market/presentation/widget/market_search_bar.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MarketCubit>()..loadMarketCoins(),
      child: const _MarketScreenContent(),
    );
  }
}

class _MarketScreenContent extends StatefulWidget {
  const _MarketScreenContent();

  @override
  State<_MarketScreenContent> createState() => _MarketScreenContentState();
}

class _MarketScreenContentState extends State<_MarketScreenContent> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isSearching) return; // Don't load more while searching

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.8; // Load more at 80% scroll

    if (currentScroll >= threshold) {
      context.read<MarketCubit>().loadMoreMarketCoins();
    }
  }

  void _onSearchChanged(String query) {
    final cubit = context.read<MarketCubit>();

    if (query.trim().isEmpty) {
      setState(() => _isSearching = false);
      cubit.clearSearch();
    } else {
      setState(() => _isSearching = true);
      cubit.searchCoins(query);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _isSearching = false);
    context.read<MarketCubit>().clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
              Padding(
                padding: AppSpacing.paddingHV(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.gapH20,
                    Text(
                    context.tr.cryptoMarketTitle,
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: isDark ? AppColors.textWhite : AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.gapH20,
                  MarketSearchBar(
                    controller: _searchController,
                    hintText: context.tr.searchHint,
                    onChanged: _onSearchChanged,
                    trailing: _isSearching
                        ? IconButton(
                            icon: Icon(
                              Icons.close,
                              size: AppSizing.iconMedium,
                              color: isDark
                                  ? AppColors.textWhiteSoft
                                  : AppColors.textGray,
                            ),
                            onPressed: _clearSearch,
                          )
                        : SvgPicture.asset(
                            AppAssets.swap,
                            height: AppSizing.iconMedium,
                            colorFilter: ColorFilter.mode(
                              isDark
                                  ? AppColors.textWhiteSoft
                                  : AppColors.textGray,
                              BlendMode.srcIn,
                            ),
                          ),
                  ),
                  AppSpacing.gapH20,
                ],
              ),
            ),
            Expanded(
              child: _isSearching
                  ? _buildSearchResults(isDark)
                  : _buildMarketList(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketList(bool isDark) {
    return BlocBuilder<MarketCubit, MarketState>(
      builder: (context, state) {
        if (state is MarketLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MarketError) {
          return _buildError(state.message, isDark);
        }

        if (state is MarketLoaded) {
          if (state.coins.isEmpty) {
            return _buildEmpty(context.tr.noCoinsFound, isDark);
          }

          return RefreshIndicator(
            onRefresh: () => context.read<MarketCubit>().refreshMarketCoins(),
            child: ListView.builder(
              controller: _scrollController,
              padding: AppSpacing.paddingHV(horizontal: 16, vertical: 0),
              itemCount: state.coins.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.coins.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final coin = state.coins[index];
                return Padding(
                  padding: AppSpacing.marginOnly(bottom: 16),
                  child: MarketCoinTile(
                    name: coin.name,
                    rank: coin.marketCapRank,
                    price: coin.currentPrice,
                    changePercentage: coin.priceChangePercentage24h,
                    imageUrl: coin.image,
                    accentColor: AppColors.primary,
                    isDark: isDark,
                    onTap: () {
                      context.push(RoutePaths.buySellRoute(coin.id));
                    },
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSearchResults(bool isDark) {
    return BlocBuilder<MarketCubit, MarketState>(
      builder: (context, state) {
        if (state is! MarketLoaded) {
          return const SizedBox.shrink();
        }
        final searchState = state.searchState;

        if (searchState is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (searchState is SearchError) {
          return _buildError(searchState.message, isDark);
        }

        if (searchState is SearchLoaded) {
          if (searchState.searchResults.isEmpty) {
            return _buildEmpty(
              context.tr.noResultsFound(searchState.query),
              isDark,
            );
          }

          return Column(
            children: [
              Padding(
                padding: AppSpacing.paddingHV(horizontal: 16, vertical: 8),
                child: Container(
                  padding: AppSpacing.paddingH12V8,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      AppSpacing.gapW8,
                      Expanded(
                        child: Text(
                          context.tr.tapAnyCoin,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.textWhite : AppColors.primary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: AppSpacing.paddingHV(horizontal: 16, vertical: 0),
                  itemCount: searchState.searchResults.length,
                  itemBuilder: (context, index) {
                    final coin = searchState.searchResults[index];
                    return Padding(
                      padding: AppSpacing.marginOnly(bottom: 16),
                      child: MarketCoinTile(
                        name: coin.name,
                        rank: coin.marketCapRank,
                        price: coin.currentPrice,
                        changePercentage: coin.priceChangePercentage24h,
                        imageUrl: coin.image,
                        accentColor: AppColors.primary,
                        isDark: isDark,
                        onTap: () {
                          context.push(RoutePaths.buySellRoute(coin.id));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildError(String message, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: isDark ? AppColors.textGrayLight : AppColors.textGray,
            ),
            AppSpacing.gapH16,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isDark ? AppColors.textWhiteSoft : AppColors.textGray,
              ),
            ),
            AppSpacing.gapH20,
            ElevatedButton(
              onPressed: () {
                if (_isSearching) {
                  _onSearchChanged(_searchController.text);
                } else {
                  context.read<MarketCubit>().loadMarketCoins();
                }
              },
              child: Text(context.tr.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(String message, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: isDark ? AppColors.textGrayLight : AppColors.textGray,
            ),
            AppSpacing.gapH16,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isDark ? AppColors.textWhiteSoft : AppColors.textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
