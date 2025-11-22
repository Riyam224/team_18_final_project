import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/features/home/presentation/widgets/top_gainer_tile.dart';

class TopGainersList extends StatelessWidget {
  const TopGainersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopGainerTile(
          name: "Ethereum",
          symbol: "ETH",
          price: "\$20,788",
          percentage: "+0.25%",
          imageUrl:
              "https://assets.coingecko.com/coins/images/279/large/ethereum.png",
        ),
        SizedBox(height: 12.h),
        const TopGainerTile(
          name: "Binance Coin",
          symbol: "BNB",
          price: "\$20,788",
          percentage: "+1.15%",
          imageUrl:
              "https://assets.coingecko.com/coins/images/825/large/binance-coin-logo.png",
        ),
      ],
    );
  }
}
