import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/home/presentation/widgets/crypto_item_tile.dart';

class TrendingNowList extends StatelessWidget {
  const TrendingNowList({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CryptoItemTile(
            name: AppStrings.bitcoin,
            symbol: "BTC",
            price: "1,132,151",
            percentage: "2.35%",
            iconColor: AppColors.bitcoin, // Bitcoin orange
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CryptoItemTile(
            name: AppStrings.ethereum,
            symbol: "ETH",
            price: "1,132,151",
            percentage: "2.35%",
            iconColor: AppColors.ethereum, // Ethereum blue
          ),
        ),
      ],
    );
  }
}
