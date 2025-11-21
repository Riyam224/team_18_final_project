import 'package:flutter/material.dart';
import 'package:team_18_final_project/features/home/presentation/widgets/crypto_item_tile.dart';

class TrendingNowList extends StatelessWidget {
  const TrendingNowList({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CryptoItemTile(
            name: "Bitcoin",
            symbol: "BTC",
            price: "1,132,151",
            percentage: "2.35%",
            iconColor: const Color(0xFFF7931A), // Bitcoin orange
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CryptoItemTile(
            name: "Ethereum",
            symbol: "ETH",
            price: "1,132,151",
            percentage: "2.35%",
            iconColor: const Color(0xFF627EEA), // Ethereum blue
          ),
        ),
      ],
    );
  }
}
