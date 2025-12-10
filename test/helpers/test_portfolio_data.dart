import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_holding.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';

/// Shared test fixtures for the portfolio feature.
class TestPortfolioData {
  const TestPortfolioData._();

  /// Default BTC holding used across tests.
  static PortfolioHolding btc({
    double amount = 0.5,
    double priceUsd = 50000.0,
    double changePercent24h = 5.0,
  }) {
    return PortfolioHolding(
      id: 'bitcoin',
      name: 'Bitcoin',
      symbol: 'BTC',
      amount: amount,
      priceUsd: priceUsd,
      changePercent24h: changePercent24h,
    );
  }

  /// Default ETH holding used across tests.
  static PortfolioHolding eth({
    double amount = 2.0,
    double priceUsd = 3000.0,
    double changePercent24h = -2.0,
  }) {
    return PortfolioHolding(
      id: 'ethereum',
      name: 'Ethereum',
      symbol: 'ETH',
      amount: amount,
      priceUsd: priceUsd,
      changePercent24h: changePercent24h,
    );
  }

  /// Default LTC holding used across tests.
  static PortfolioHolding ltc({
    double amount = 10.0,
    double priceUsd = 150.0,
    double changePercent24h = 1.5,
  }) {
    return PortfolioHolding(
      id: 'litecoin',
      name: 'Litecoin',
      symbol: 'LTC',
      amount: amount,
      priceUsd: priceUsd,
      changePercent24h: changePercent24h,
    );
  }

  /// Convenience overview for BTC + ETH.
  static PortfolioOverview overview({
    List<PortfolioHolding>? holdings,
  }) {
    return PortfolioOverview(
      holdings: holdings ?? [btc(), eth()],
    );
  }
}
