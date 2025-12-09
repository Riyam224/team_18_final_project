import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';
import '../../../../helpers/test_portfolio_data.dart';

void main() {
  group('PortfolioOverview', () {
    test('calculates total value from holdings', () {
      final overview = TestPortfolioData.overview();
      expect(overview.totalValue, 31000.0);
    });

    test('calculates total change in USD', () {
      final overview = TestPortfolioData.overview();
      expect(overview.totalChangeUsd, 1130.0);
    });

    test('calculates total change percent', () {
      final overview = TestPortfolioData.overview();
      expect(overview.totalChangePercent, closeTo(3.65, 0.2));
    });

    test('handles empty portfolio', () {
      const emptyOverview = PortfolioOverview(holdings: []);
      expect(emptyOverview.totalValue, 0);
      expect(emptyOverview.totalChangeUsd, 0);
      expect(emptyOverview.totalChangePercent, 0);
    });

    test('equality works correctly', () {
      final overview1 = TestPortfolioData.overview();
      final overview2 = TestPortfolioData.overview();
      expect(overview1, equals(overview2));
    });
  });
}
