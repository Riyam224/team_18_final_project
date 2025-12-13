import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:team_18_final_project/core/common_ui/widgets/primary_appBar.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/market/presentation/cubit/coin_details_cubit.dart';
import 'package:team_18_final_project/features/market/presentation/cubit/coin_details_state.dart';
import 'package:team_18_final_project/features/market/presentation/widget/bitcoin_name_with_image.dart';
import 'package:team_18_final_project/features/market/presentation/widget/bitcoin_title_description.dart';
import 'package:team_18_final_project/features/market/presentation/widget/crypto_price_chart.dart';
import 'package:team_18_final_project/features/market/presentation/widget/market_stats_list.dart';
import 'package:team_18_final_project/features/market/presentation/widget/trade_bottom_bar.dart';

class CoinDetailsScreen extends StatelessWidget {
  final String coinId;

  const CoinDetailsScreen({
    super.key,
    required this.coinId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CoinDetailsCubit>(
      create: (context) => sl<CoinDetailsCubit>()..loadCoinDetails(coinId),
      child: _CoinDetailsScreenContent(coinId: coinId),
    );
  }
}

class _CoinDetailsScreenContent extends StatelessWidget {
  final String coinId;

  const _CoinDetailsScreenContent({required this.coinId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: _buildAppBar(context, isDark),
      body: BlocBuilder<CoinDetailsCubit, CoinDetailsState>(
        builder: (context, state) {
          if (state is CoinDetailsLoading || state is CoinDetailsInitial) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: isDark ? AppColors.lightSurface : AppColors.primary,
                  ),
                  AppSpacing.gapH20,
                  Text(
                    'Loading coin details...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? AppColors.textWhiteSoft : AppColors.textGray,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is CoinDetailsError) {
            return _buildError(context, state.message, isDark);
          }

          if (state is CoinDetailsLoaded) {
            return _buildContent(context, state, isDark);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar:
          BlocBuilder<CoinDetailsCubit, CoinDetailsState>(
        builder: (context, state) {
          final coin = state is CoinDetailsLoaded ? state.coin : null;
          return TradeBottomBar(
            coinId: coinId,
            coin: coin,
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return PrimaryAppBar(
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Icon(
          Icons.arrow_back_rounded,
          color: isDark ? AppColors.textWhite : AppColors.primary,
          size: 28,
        ),
      ),
      title: BlocBuilder<CoinDetailsCubit, CoinDetailsState>(
        builder: (context, state) {
          final title = state is CoinDetailsLoaded
              ? state.coin.name
              : context.tr.coinDetailsTitle;
          return Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 22.sp,
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, CoinDetailsLoaded state, bool isDark) {
    return RefreshIndicator(
      onRefresh: () =>
          context.read<CoinDetailsCubit>().loadCoinDetails(coinId),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16).r,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.vertical(24),
                  BitcoinNameWithImage(
                    coinName: state.coin.name,
                    imageUrl: state.coin.image ?? '',
                  ),
                  AppSpacing.vertical(24),
                  CryptoPriceChart(
                    chartData:
                        state.chartPoints.map((p) => FlSpot(p.x, p.y)).toList(),
                    currentPrice: state.coin.currentPrice,
                    changePercentage: state.coin.priceChangePercentage24h ?? 0,
                    selectedPeriod: state.selectedPeriod,
                    onPeriodChanged: (period) {
                      context.read<CoinDetailsCubit>().updateChartPeriod(period);
                    },
                  ),
                  if (state.chartLoading) ...[
                    AppSpacing.gapH12,
                    Center(
                      child: SizedBox(
                        height: 18.r,
                        width: 18.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: isDark
                              ? AppColors.textWhite
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                  AppSpacing.vertical(32),
                  Text(
                    context.tr.staticsTitle,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          color: isDark
                              ? AppColors.textWhite
                              : AppColors.primary,
                        ),
                  ),
                  AppSpacing.vertical(16),
                ],
              ),
            ),
            MarketStatsList(stats: state.coin.marketStats),
            SliverToBoxAdapter(child: AppSpacing.vertical(24)),
            SliverToBoxAdapter(
              child: BitcoinTitleDescription(description: state.coin.description),
            ),
            SliverToBoxAdapter(child: AppSpacing.vertical(100)),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.alertRed.withValues(alpha: 0.1)
                    : AppColors.lightPink,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64.sp,
                color: AppColors.alertRed,
              ),
            ),
            AppSpacing.gapH24,
            Text(
              'Oops!',
              style: AppTextStyles.headlineMedium.copyWith(
                color: isDark ? AppColors.textWhite : AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
              ),
            ),
            AppSpacing.gapH12,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isDark ? AppColors.textWhiteSoft : AppColors.textGray,
                fontSize: 16.sp,
                height: 1.5,
              ),
            ),
            AppSpacing.gapH32,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    side: BorderSide(
                      color: isDark ? AppColors.textWhiteSoft : AppColors.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      color: isDark ? AppColors.textWhite : AppColors.primary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                ElevatedButton(
                  onPressed: () {
                    context.read<CoinDetailsCubit>().loadCoinDetails(coinId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.lightSurface : AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
