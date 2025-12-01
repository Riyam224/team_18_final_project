import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_holding.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';

void main() {
  group('PortfolioOverview Entity Tests', () {
    late List<PortfolioHolding> sampleHoldings;
    late PortfolioOverview overview;

    setUp(() {
      sampleHoldings = [
        const PortfolioHolding(
          id: 'bitcoin',
          name: 'Bitcoin',
          symbol: 'BTC',
          amount: 0.5,
          priceUsd: 50000.0,
          changePercent24h: 5.0,
          icon: Icons.currency_bitcoin,
          iconColor: Colors.orange,
        ),
        const PortfolioHolding(
          id: 'ethereum',
          name: 'Ethereum',
          symbol: 'ETH',
          amount: 2.0,
          priceUsd: 3000.0,
          changePercent24h: -2.0,
          icon: Icons.currency_exchange,
          iconColor: Colors.blue,
        ),
      ];
      overview = PortfolioOverview(holdings: sampleHoldings);
    });

    group('Constructor', () {
      test('should create a valid PortfolioOverview instance', () {
        expect(overview.holdings, sampleHoldings);
        expect(overview.holdings.length, 2);
      });

      test('should create empty portfolio', () {
        final emptyOverview = const PortfolioOverview(holdings: []);
        expect(emptyOverview.holdings, isEmpty);
      });

      test('should create portfolio with single holding', () {
        final singleOverview = PortfolioOverview(
          holdings: [sampleHoldings[0]],
        );
        expect(singleOverview.holdings.length, 1);
      });
    });

    group('totalValue Calculation', () {
      test('should calculate total value correctly with multiple holdings', () {
        // BTC: 0.5 * $50,000 = $25,000
        // ETH: 2.0 * $3,000 = $6,000
        // Total: $31,000
        expect(overview.totalValue, 31000.0);
      });

      test('should return zero for empty portfolio', () {
        final emptyOverview = const PortfolioOverview(holdings: []);
        expect(emptyOverview.totalValue, 0.0);
      });

      test('should calculate correctly with single holding', () {
        final singleOverview = PortfolioOverview(
          holdings: [sampleHoldings[0]],
        );
        expect(singleOverview.totalValue, 25000.0);
      });

      test('should handle zero value holdings', () {
        final holdingsWithZero = [
          sampleHoldings[0],
          const PortfolioHolding(
            id: 'zero',
            name: 'Zero',
            symbol: 'ZRO',
            amount: 0,
            priceUsd: 1000.0,
            changePercent24h: 0,
            icon: Icons.money,
            iconColor: Colors.grey,
          ),
        ];
        final overviewWithZero = PortfolioOverview(holdings: holdingsWithZero);
        expect(overviewWithZero.totalValue, 25000.0);
      });

      test('should handle large portfolio values', () {
        final largeHoldings = [
          const PortfolioHolding(
            id: 'btc1',
            name: 'Bitcoin',
            symbol: 'BTC',
            amount: 100.0,
            priceUsd: 50000.0,
            changePercent24h: 5.0,
            icon: Icons.currency_bitcoin,
            iconColor: Colors.orange,
          ),
          const PortfolioHolding(
            id: 'eth1',
            name: 'Ethereum',
            symbol: 'ETH',
            amount: 1000.0,
            priceUsd: 3000.0,
            changePercent24h: -2.0,
            icon: Icons.currency_exchange,
            iconColor: Colors.blue,
          ),
        ];
        final largeOverview = PortfolioOverview(holdings: largeHoldings);
        // BTC: 100 * $50,000 = $5,000,000
        // ETH: 1000 * $3,000 = $3,000,000
        // Total: $8,000,000
        expect(largeOverview.totalValue, 8000000.0);
      });

      test('should handle decimal precision in total value', () {
        final preciseHoldings = [
          const PortfolioHolding(
            id: 'btc',
            name: 'Bitcoin',
            symbol: 'BTC',
            amount: 0.123456,
            priceUsd: 50000.5,
            changePercent24h: 5.0,
            icon: Icons.currency_bitcoin,
            iconColor: Colors.orange,
          ),
        ];
        final preciseOverview = PortfolioOverview(holdings: preciseHoldings);
        expect(preciseOverview.totalValue, closeTo(6172.861728, 0.00001));
      });
    });

    group('totalChangeUsd Calculation', () {
      test('should calculate total change with mixed positive and negative', () {
        // BTC change: $25,000 * 0.05 = $1,250
        // ETH change: $6,000 * -0.02 = -$120
        // Total change: $1,130
        expect(overview.totalChangeUsd, 1130.0);
      });

      test('should return zero for empty portfolio', () {
        final emptyOverview = const PortfolioOverview(holdings: []);
        expect(emptyOverview.totalChangeUsd, 0.0);
      });

      test('should handle all positive changes', () {
        final allPositive = [
          const PortfolioHolding(
            id: 'btc',
            name: 'Bitcoin',
            symbol: 'BTC',
            amount: 1.0,
            priceUsd: 50000.0,
            changePercent24h: 5.0,
            icon: Icons.currency_bitcoin,
            iconColor: Colors.orange,
          ),
          const PortfolioHolding(
            id: 'eth',
            name: 'Ethereum',
            symbol: 'ETH',
            amount: 1.0,
            priceUsd: 3000.0,
            changePercent24h: 3.0,
            icon: Icons.currency_exchange,
            iconColor: Colors.blue,
          ),
        ];
        final positiveOverview = PortfolioOverview(holdings: allPositive);
        // BTC: $50,000 * 0.05 = $2,500
        // ETH: $3,000 * 0.03 = $90
        // Total: $2,590
        expect(positiveOverview.totalChangeUsd, 2590.0);
      });

      test('should handle all negative changes', () {
        final allNegative = [
          const PortfolioHolding(
            id: 'btc',
            name: 'Bitcoin',
            symbol: 'BTC',
            amount: 1.0,
            priceUsd: 50000.0,
            changePercent24h: -5.0,
            icon: Icons.currency_bitcoin,
            iconColor: Colors.orange,
          ),
          const PortfolioHolding(
            id: 'eth',
            name: 'Ethereum',
            symbol: 'ETH',
            amount: 1.0,
            priceUsd: 3000.0,
            changePercent24h: -3.0,
            icon: Icons.currency_exchange,
            iconColor: Colors.blue,
          ),
        ];
        final negativeOverview = PortfolioOverview(holdings: allNegative);
        // BTC: $50,000 * -0.05 = -$2,500
        // ETH: $3,000 * -0.03 = -$90
        // Total: -$2,590
        expect(negativeOverview.totalChangeUsd, -2590.0);
      });

      test('should handle zero changes', () {
        final noChange = [
          const PortfolioHolding(
            id: 'btc',
            name: 'Bitcoin',
            symbol: 'BTC',
            amount: 1.0,
            priceUsd: 50000.0,
            changePercent24h: 0.0,
            icon: Icons.currency_bitcoin,
            iconColor: Colors.orange,
          ),
        ];
        final noChangeOverview = PortfolioOverview(holdings: noChange);
        expect(noChangeOverview.totalChangeUsd, 0.0);
      });
    });

    group('totalChangePercent Calculation', () {
      test('should calculate percentage correctly with mixed changes', () {
        // totalValue = $31,000
        // totalChangeUsd = $1,130
        // originalValue = $31,000 - $1,130 = $29,870
        // changePercent = ($1,130 / $29,870) * 100 = 3.78%
        expect(overview.totalChangePercent, closeTo(3.782, 0.001));
      });

      test('should return zero for empty portfolio', () {
        final emptyOverview = const PortfolioOverview(holdings: []);
        expect(emptyOverview.totalChangePercent, 0.0);
      });

      test('should handle zero total value', () {
        final zeroValue = const PortfolioOverview(
          holdings: [
            PortfolioHolding(
              id: 'zero',
              name: 'Zero',
              symbol: 'ZRO',
              amount: 0,
              priceUsd: 0,
              changePercent24h: 5.0,
              icon: Icons.money,
              iconColor: Colors.grey,
            ),
          ],
        );
        expect(zeroValue.totalChangePercent, 0.0);
      });

      test('should calculate large positive percentage', () {
        final bigGain = [
          const PortfolioHolding(
            id: 'btc',
            name: 'Bitcoin',
            symbol: 'BTC',
            amount: 1.0,
            priceUsd: 50000.0,
            changePercent24h: 50.0,
            icon: Icons.currency_bitcoin,
            iconColor: Colors.orange,
          ),
        ];
        final bigGainOverview = PortfolioOverview(holdings: bigGain);
        // changeUsd = $25,000
        // originalValue = $50,000 - $25,000 = $25,000
        // percent = ($25,000 / $25,000) * 100 = 100%
        expect(bigGainOverview.totalChangePercent, closeTo(100.0, 0.1));
      });

      test('should calculate negative percentage', () {
        final loss = [
          const PortfolioHolding(
            id: 'btc',
            name: 'Bitcoin',
            symbol: 'BTC',
            amount: 1.0,
            priceUsd: 50000.0,
            changePercent24h: -10.0,
            icon: Icons.currency_bitcoin,
            iconColor: Colors.orange,
          ),
        ];
        final lossOverview = PortfolioOverview(holdings: loss);
        // changeUsd = -$5,000
        // originalValue = $50,000 - (-$5,000) = $55,000
        // percent = (-$5,000 / $55,000) * 100 = -9.09%
        expect(lossOverview.totalChangePercent, closeTo(-9.09, 0.01));
      });

      test('should handle extreme negative change edge case', () {
        final extremeLoss = [
          const PortfolioHolding(
            id: 'btc',
            name: 'Bitcoin',
            symbol: 'BTC',
            amount: 1.0,
            priceUsd: 50000.0,
            changePercent24h: -99.0,
            icon: Icons.currency_bitcoin,
            iconColor: Colors.orange,
          ),
        ];
        final extremeLossOverview = PortfolioOverview(holdings: extremeLoss);
        // changeUsd = -$49,500
        // originalValue = $50,000 - (-$49,500) = $99,500
        // percent = (-$49,500 / $99,500) * 100 ≈ -49.75%
        expect(extremeLossOverview.totalChangePercent, closeTo(-49.75, 0.01));
      });
    });

    group('Equatable Properties', () {
      test('should be equal when holdings are the same', () {
        final overview1 = PortfolioOverview(holdings: sampleHoldings);
        final overview2 = PortfolioOverview(holdings: sampleHoldings);

        expect(overview1, equals(overview2));
        expect(overview1.hashCode, equals(overview2.hashCode));
      });

      test('should not be equal when holdings differ', () {
        final overview1 = PortfolioOverview(holdings: sampleHoldings);
        final overview2 = PortfolioOverview(holdings: [sampleHoldings[0]]);

        expect(overview1, isNot(equals(overview2)));
      });

      test('should not be equal when holdings order differs', () {
        final overview1 = PortfolioOverview(holdings: sampleHoldings);
        final overview2 = PortfolioOverview(
          holdings: sampleHoldings.reversed.toList(),
        );

        expect(overview1, isNot(equals(overview2)));
      });
    });

    group('Edge Cases', () {
      test('should handle many holdings efficiently', () {
        final manyHoldings = List.generate(
          100,
          (i) => PortfolioHolding(
            id: 'coin$i',
            name: 'Coin $i',
            symbol: 'C$i',
            amount: 1.0,
            priceUsd: 100.0,
            changePercent24h: 1.0,
            icon: Icons.monetization_on,
            iconColor: Colors.green,
          ),
        );
        final manyOverview = PortfolioOverview(holdings: manyHoldings);

        expect(manyOverview.totalValue, 10000.0); // 100 * $100
        expect(manyOverview.totalChangeUsd, 100.0); // 100 * ($100 * 0.01)
      });

      test('should handle very small values', () {
        final tinyHolding = const PortfolioOverview(
          holdings: [
            PortfolioHolding(
              id: 'tiny',
              name: 'Tiny',
              symbol: 'TNY',
              amount: 0.00001,
              priceUsd: 0.001,
              changePercent24h: 0.01,
              icon: Icons.money,
              iconColor: Colors.grey,
            ),
          ],
        );

        expect(tinyHolding.totalValue, closeTo(0.00000001, 0.00000001));
      });

      test('should maintain precision with mixed large and small values', () {
        final mixedHoldings = [
          const PortfolioHolding(
            id: 'large',
            name: 'Large',
            symbol: 'LRG',
            amount: 1000.0,
            priceUsd: 50000.0,
            changePercent24h: 5.0,
            icon: Icons.trending_up,
            iconColor: Colors.green,
          ),
          const PortfolioHolding(
            id: 'small',
            name: 'Small',
            symbol: 'SML',
            amount: 0.0001,
            priceUsd: 0.01,
            changePercent24h: 10.0,
            icon: Icons.trending_down,
            iconColor: Colors.red,
          ),
        ];
        final mixedOverview = PortfolioOverview(holdings: mixedHoldings);

        // Large: 1000 * $50,000 = $50,000,000
        // Small: 0.0001 * $0.01 = $0.000001
        expect(mixedOverview.totalValue, closeTo(50000000.000001, 0.000001));
      });
    });
  });
}
