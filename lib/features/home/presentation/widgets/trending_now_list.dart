import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/home/domain/entities/trending_coin.dart';
import 'package:team_18_final_project/features/home/presentation/widgets/crypto_item_tile.dart';

class TrendingNowList extends StatelessWidget {
  final List<TrendingCoinEntity> trendingCoins;

  const TrendingNowList({super.key, required this.trendingCoins});

  Color _getCoinColor(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'BTC':
        return AppColors.btcOrange;
      case 'ETH':
        return AppColors.ethBlue;
      case 'BNB':
        return AppColors.bnbYellow;
      case 'XRP':
        return AppColors.xrpBlack;
      case 'ADA':
        return AppColors.adaBlue;
      case 'SOL':
        return AppColors.solGreen;
      case 'DOGE':
        return AppColors.dogeYellow;
      default:
        return AppColors.defaultCoin;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (trendingCoins.isEmpty) {
      return SizedBox(
        height: 110.h,
        child: const Center(
          child: Text('No trending coins available'),
        ),
      );
    }

    return SizedBox(
      height: 110.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(right: 16.w),
        itemCount: trendingCoins.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final coin = trendingCoins[index];
          return TrendingCryptoCard(
            name: coin.name,
            symbol: coin.symbol,
            price: coin.price,
            percentage:
                "${coin.priceChangePercentage24h >= 0 ? '+' : ''}${coin.priceChangePercentage24h.toStringAsFixed(2)}%",
            iconColor: _getCoinColor(coin.symbol),
            iconData: Icons.currency_bitcoin,
          );
        },
      ),
    );
  }
}
