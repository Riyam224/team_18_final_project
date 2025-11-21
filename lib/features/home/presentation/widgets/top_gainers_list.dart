import 'package:flutter/material.dart';
import 'package:team_18_final_project/features/home/presentation/widgets/crypto_item_tile.dart';

class TopGainersList extends StatelessWidget {
  const TopGainersList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CryptoItemTile(
          name: "Ethereum",
          symbol: "ETH",
          price: "\$20,788",
          percentage: "+0.25%",
        ),
        SizedBox(height: 12),
        CryptoItemTile(
          name: "Binance Coin",
          symbol: "BNS",
          price: "\$20,788",
          percentage: "+1.15%",
        ),
        SizedBox(height: 12),
        CryptoItemTile(
          name: "Litecoin",
          symbol: "LTC",
          price: "\$20,788",
          percentage: "+1.15%",
        ),
      ],
    );
  }
}
