import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_holding.dart';
import '../../../../helpers/test_portfolio_data.dart';

void main() {
  group('PortfolioHolding', () {
    late PortfolioHolding holding;

    setUp(() {
      holding = TestPortfolioData.btc();
    });

    test('creates valid instance with correct properties', () {
      expect(holding.id, 'bitcoin');
      expect(holding.name, 'Bitcoin');
      expect(holding.symbol, 'BTC');
      expect(holding.amount, 0.5);
      expect(holding.priceUsd, 50000.0);
      expect(holding.changePercent24h, 5.0);
    });

    test('calculates valueUsd correctly', () {
      expect(holding.valueUsd, 25000.0);
    });

    test('calculates changeUsd correctly', () {
      expect(holding.changeUsd, 1250.0);
    });

    test('handles negative change', () {
      final negativeHolding = const PortfolioHolding(
        id: 'ethereum',
        name: 'Ethereum',
        symbol: 'ETH',
        amount: 2.0,
        priceUsd: 3000.0,
        changePercent24h: -2.0,
      );

      expect(negativeHolding.changeUsd, -120.0);
    });

    test('equality works correctly', () {
      final holding1 = TestPortfolioData.btc();
      final holding2 = TestPortfolioData.btc();

      expect(holding1, equals(holding2));
    });
  });
}
