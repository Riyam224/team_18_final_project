import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/features/home/domain/entities/trending_coin.dart';
import 'package:team_18_final_project/features/home/presentation/widgets/crypto_item_tile.dart';

class TrendingNowList extends StatelessWidget {
  final List<TrendingCoinEntity> trendingCoins;

  const TrendingNowList({super.key, required this.trendingCoins});

  Color _getCoinColor(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'BTC':
        return const Color(0xFFF7931A);
      case 'ETH':
        return const Color(0xFF627EEA);
      case 'BNB':
        return const Color(0xFFF3BA2F);
      case 'XRP':
        return const Color(0xFF23292F);
      case 'ADA':
        return const Color(0xFF0033AD);
      case 'SOL':
        return const Color(0xFF14F195);
      case 'DOGE':
        return const Color(0xFFC2A633);
      default:
        return const Color(0xFF6366F1);
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
