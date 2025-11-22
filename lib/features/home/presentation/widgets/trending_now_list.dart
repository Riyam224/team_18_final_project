import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/features/home/presentation/widgets/crypto_item_tile.dart';

class TrendingNowList extends StatelessWidget {
  const TrendingNowList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(right: 16.w),
        children: [
          const TrendingCryptoCard(
            name: "Bitcoin",
            symbol: "BTC",
            price: "1,132,151",
            percentage: "+2.35%",
            iconColor: Color(0xFFF7931A), // Bitcoin Orange
            iconData: Icons.currency_bitcoin,
          ),
          SizedBox(width: 12.w),
          const TrendingCryptoCard(
            name: "Ethereum",
            symbol: "ETH",
            price: "1,132,151",
            percentage: "+2.35%",
            iconColor: Color(0xFF627EEA), // Ethereum Blue
            iconData:
                Icons.currency_bitcoin, // replace with real ETH icon later
          ),
        ],
      ),
    );
  }
}
