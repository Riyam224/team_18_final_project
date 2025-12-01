import 'package:flutter/material.dart';

/// Local/seeded holdings for the portfolio feature.
/// In a real app this could read from secure storage or a database.
class PortfolioLocalDataSource {
  List<HoldingSeed> getInitialHoldings() => const [
        HoldingSeed(
          id: 'bitcoin',
          name: 'Bitcoin',
          symbol: 'BTC',
          amount: 0.05,
          icon: Icons.currency_bitcoin,
          iconColor: Color(0xFFF7931A),
        ),
        HoldingSeed(
          id: 'ethereum',
          name: 'Ethereum',
          symbol: 'ETH',
          amount: 1.5,
          icon: Icons.token,
          iconColor: Color(0xFF627EEA),
        ),
        HoldingSeed(
          id: 'litecoin',
          name: 'Litecoin',
          symbol: 'LTC',
          amount: 26.3,
          icon: Icons.currency_exchange,
          iconColor: Color(0xFF345D9D),
        ),
      ];
}

class HoldingSeed {
  final String id;
  final String name;
  final String symbol;
  final double amount;
  final IconData icon;
  final Color iconColor;

  const HoldingSeed({
    required this.id,
    required this.name,
    required this.symbol,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });
}
