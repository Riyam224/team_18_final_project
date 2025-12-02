import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_holding.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';
import '../../../../helpers/test_portfolio_data.dart';
import '../../../../helpers/test_utils.dart';

void main() {
  group('PortfolioOverview', () {
    late List<PortfolioHolding> sampleHoldings;
    late PortfolioOverview overview;

    setUp(() {
      sampleHoldings = [
        TestPortfolioData.btc(),
        TestPortfolioData.eth(),
      ];
      overview = PortfolioOverview(holdings: sampleHoldings);
    });

    test('constructs with provided holdings', () {
      expect(overview.holdings, sampleHoldings);
      expect(overview.holdings, hasLength(2));
    });

    test('supports empty portfolio', () {
      const emptyOverview = PortfolioOverview(holdings: []);
      expect(emptyOverview.totalValue, 0);
      expect(emptyOverview.totalChangeUsd, 0);
      expect(emptyOverview.totalChangePercent, 0);
    });

    group('totalValue', () {
      test('aggregates multiple holdings', () {
        expectClose(overview.totalValue, 31000.0);
      });

      test('handles single holding', () {
        final single = PortfolioOverview(holdings: [sampleHoldings.first]);
        expectClose(single.totalValue, 25000.0);
      });

      test('ignores zero-value holdings', () {
        final withZero = PortfolioOverview(
          holdings: [
            sampleHoldings.first,
            const PortfolioHolding(
              id: 'zero',
              name: 'Zero',
              symbol: 'ZRO',
              amount: 0,
              priceUsd: 1000,
              changePercent24h: 0,
            ),
          ],
        );
        expectClose(withZero.totalValue, 25000.0);
      });
    });

    group('totalChangeUsd', () {
      test('sums positive and negative changes', () {
        expectClose(overview.totalChangeUsd, 1130.0);
      });

      test('handles all positive changes', () {
        final positive = PortfolioOverview(
          holdings: [
            TestPortfolioData.btc(amount: 1.0),
            TestPortfolioData.eth(amount: 1.0, changePercent24h: 3.0),
          ],
        );
        expectClose(positive.totalChangeUsd, 2590.0);
      });

      test('handles all negative changes', () {
        final negative = PortfolioOverview(
          holdings: [
            TestPortfolioData.btc(amount: 1.0, changePercent24h: -5.0),
            TestPortfolioData.eth(amount: 1.0, changePercent24h: -3.0),
          ],
        );
        expectClose(negative.totalChangeUsd, -2590.0);
      });
    });

    group('totalChangePercent', () {
      test('calculates weighted percent with mixed changes', () {
        expectClose(overview.totalChangePercent, 3.782, delta: 0.02);
      });

      test('returns zero for empty or zero value', () {
        const zeroValue = PortfolioOverview(
          holdings: [
            PortfolioHolding(
              id: 'zero',
              name: 'Zero',
              symbol: 'ZRO',
              amount: 0,
              priceUsd: 0,
              changePercent24h: 5,
            ),
          ],
        );
        expect(zeroValue.totalChangePercent, 0);
      });

      test('handles large positive change', () {
        final gain = PortfolioOverview(
          holdings: [
            TestPortfolioData.btc(amount: 1.0, changePercent24h: 50.0),
          ],
        );
        expectClose(gain.totalChangePercent, 100.0, delta: 0.2);
      });

      test('handles negative change', () {
        final loss = PortfolioOverview(
          holdings: [
            TestPortfolioData.btc(amount: 1.0, changePercent24h: -10.0),
          ],
        );
        expectClose(loss.totalChangePercent, -9.09, delta: 0.05);
      });
    });

    group('Equatable', () {
      test('equal when holdings identical', () {
        final other = PortfolioOverview(holdings: sampleHoldings);
        expect(overview, other);
      });

      test('not equal when holdings differ', () {
        final different = PortfolioOverview(holdings: [sampleHoldings.first]);
        expect(overview == different, false);
      });
    });

    group('Edge cases', () {
      test('handles many holdings', () {
        final many = List.generate(
          100,
          (i) => PortfolioHolding(
            id: 'coin$i',
            name: 'Coin $i',
            symbol: 'C$i',
            amount: 1,
            priceUsd: 100,
            changePercent24h: 1,
          ),
        );
        final large = PortfolioOverview(holdings: many);

        expectClose(large.totalValue, 10000.0);
        expectClose(large.totalChangeUsd, 100.0);
      });

      test('maintains precision with tiny values', () {
        const tiny = PortfolioOverview(
          holdings: [
            PortfolioHolding(
              id: 'tiny',
              name: 'Tiny',
              symbol: 'TNY',
              amount: 0.00001,
              priceUsd: 0.001,
              changePercent24h: 0.01,
            ),
          ],
        );

        expectClose(tiny.totalValue, 0.00000001, delta: 1e-12);
      });
    });
  });
}
