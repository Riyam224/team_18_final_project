class PortfolioLocalDataSource {
  List<HoldingSeed> getInitialHoldings() => const [
        HoldingSeed(
          id: 'bitcoin',
          name: 'Bitcoin',
          symbol: 'BTC',
          amount: 0.05,
        ),
        HoldingSeed(
          id: 'ethereum',
          name: 'Ethereum',
          symbol: 'ETH',
          amount: 1.5,
        ),
        HoldingSeed(
          id: 'litecoin',
          name: 'Litecoin',
          symbol: 'LTC',
          amount: 26.3,
        ),
      ];
}

class HoldingSeed {
  final String id;
  final String name;
  final String symbol;
  final double amount;

  const HoldingSeed({
    required this.id,
    required this.name,
    required this.symbol,
    required this.amount,
  });
}
