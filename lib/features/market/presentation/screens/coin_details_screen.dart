import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/common_ui/widgets/primary_appBar.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/market/logic/coin_details_cubit.dart';
import 'package:team_18_final_project/features/market/logic/coin_details_state.dart';
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
      create: (context) => sl<CoinDetailsCubit>()
        ..fetchCoinDetails(coinId),    
      child: BlocConsumer<CoinDetailsCubit, CoinDetailsState>(
        listener: (context, state) {
          if (state is CoinDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          
          String appBarTitle = AppStrings.coinDetails;
          if (state is CoinDetailsSuccess) {
            appBarTitle = state.coin.name;
          }



    return Scaffold(
      appBar: PrimaryAppBar(
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
        title: Text(AppStrings.coinDetails,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 22.sp,
                  color: isDark ? AppColors.textWhite : AppColors.primary,
                )),
      ),
      body: state is CoinDetailsLoading
                ? const Center(child: CircularProgressIndicator()) 
                : state is CoinDetailsError
                    ? Center(child: Text(state.message))  
                    : state is CoinDetailsSuccess
                        ? Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ).r,
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                AppSpacing.vertical(29),
                BitcoinNameWithImage(
                  coinName: state.coin.name,
                  imageUrl: state.coin.imageUrl,
                ),
                AppSpacing.vertical(14.91),
                CryptoPriceChart(
                  chartData: state.coin.chartData?.prices ?? [],
                  currentPrice: state.coin.currentPrice,
                  changePercentage: state.coin.priceChangePercentage24h,
                  onPeriodChanged: (period) {
                    context.read<CoinDetailsCubit>().updateChartPeriod(period);
                  },
                ),                
                AppSpacing.vertical(20),
                Padding(
                  padding: const EdgeInsets.only(left: 13).r,
                  child: Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Text(AppStrings.statics,
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                  color: isDark
                                      ? AppColors.textWhite
                                      : AppColors.primary,
                                )),
                  ),
                ),
              ],
            ),
          ),
          
          MarketStatsList(stats: state.coin.marketStats),
          BitcoinTitleDescription(description: state.coin.description),
        ],
      ),
    )
  : const SizedBox(), 

            bottomNavigationBar: const TradeBottomBar(),
          );
        },),
    );
  }
}
