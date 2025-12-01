import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_holding.dart';

void main() {
  group('PortfolioHolding Entity Tests', () {
    late PortfolioHolding holding;

    setUp(() {
      holding = const PortfolioHolding(
        id: 'bitcoin',
        name: 'Bitcoin',
        symbol: 'BTC',
        amount: 0.5,
        priceUsd: 50000.0,
        changePercent24h: 5.0,
        icon: Icons.currency_bitcoin,
        iconColor: Colors.orange,
      );
    });

    group('Constructor', () {
      test('should create a valid PortfolioHolding instance', () {
        expect(holding.id, 'bitcoin');
        expect(holding.name, 'Bitcoin');
        expect(holding.symbol, 'BTC');
        expect(holding.amount, 0.5);
        expect(holding.priceUsd, 50000.0);
        expect(holding.changePercent24h, 5.0);
        expect(holding.icon, Icons.currency_bitcoin);
        expect(holding.iconColor, Colors.orange);
      });

      test('should create holding with zero amount', () {
        final zeroHolding = holding.copyWith(amount: 0);
        expect(zeroHolding.amount, 0);
      });

      test('should create holding with negative change percent', () {
        final negativeChange = holding.copyWith(changePercent24h: -3.5);
        expect(negativeChange.changePercent24h, -3.5);
      });
    });

    group('valueUsd Calculation', () {
      test('should calculate value correctly with positive values', () {
        // 0.5 BTC * $50,000 = $25,000
        expect(holding.valueUsd, 25000.0);
      });

      test('should calculate value as zero when amount is zero', () {
        final zeroHolding = holding.copyWith(amount: 0);
        expect(zeroHolding.valueUsd, 0.0);
      });

      test('should calculate value as zero when price is zero', () {
        final zeroPrice = holding.copyWith(priceUsd: 0);
        expect(zeroPrice.valueUsd, 0.0);
      });

      test('should handle large amounts correctly', () {
        final largeHolding = holding.copyWith(amount: 100.0);
        // 100 BTC * $50,000 = $5,000,000
        expect(largeHolding.valueUsd, 5000000.0);
      });

      test('should handle small fractional amounts correctly', () {
        final smallHolding = holding.copyWith(amount: 0.00001);
        // 0.00001 BTC * $50,000 = $0.50
        expect(smallHolding.valueUsd, 0.5);
      });

      test('should handle decimal precision correctly', () {
        final preciseHolding = const PortfolioHolding(
          id: 'ethereum',
          name: 'Ethereum',
          symbol: 'ETH',
          amount: 1.23456789,
          priceUsd: 3000.123,
          changePercent24h: 2.5,
          icon: Icons.currency_exchange,
          iconColor: Colors.blue,
        );
        // 1.23456789 * 3000.123 = 3703.873...
        expect(preciseHolding.valueUsd, closeTo(3703.873, 0.001));
      });
    });

    group('changeUsd Calculation', () {
      test('should calculate positive change correctly', () {
        // valueUsd = $25,000
        // changeUsd = $25,000 * (5.0 / 100) = $1,250
        expect(holding.changeUsd, 1250.0);
      });

      test('should calculate negative change correctly', () {
        final negativeChange = holding.copyWith(changePercent24h: -3.0);
        // valueUsd = $25,000
        // changeUsd = $25,000 * (-3.0 / 100) = -$750
        expect(negativeChange.changeUsd, -750.0);
      });

      test('should return zero when change percent is zero', () {
        final noChange = holding.copyWith(changePercent24h: 0);
        expect(noChange.changeUsd, 0.0);
      });

      test('should handle large positive changes', () {
        final bigChange = holding.copyWith(changePercent24h: 50.0);
        // $25,000 * 0.50 = $12,500
        expect(bigChange.changeUsd, 12500.0);
      });

      test('should handle large negative changes', () {
        final bigDrop = holding.copyWith(changePercent24h: -25.0);
        // $25,000 * -0.25 = -$6,250
        expect(bigDrop.changeUsd, -6250.0);
      });

      test('should return zero when value is zero', () {
        final zeroValue = holding.copyWith(amount: 0);
        expect(zeroValue.changeUsd, 0.0);
      });

      test('should calculate change with decimal percentages', () {
        final decimalChange = holding.copyWith(changePercent24h: 2.53);
        // $25,000 * 0.0253 = $632.50
        expect(decimalChange.changeUsd, 632.5);
      });
    });

    group('Equatable Properties', () {
      test('should be equal when all properties are the same', () {
        final holding1 = const PortfolioHolding(
          id: 'bitcoin',
          name: 'Bitcoin',
          symbol: 'BTC',
          amount: 1.0,
          priceUsd: 50000.0,
          changePercent24h: 5.0,
          icon: Icons.currency_bitcoin,
          iconColor: Colors.orange,
        );

        final holding2 = const PortfolioHolding(
          id: 'bitcoin',
          name: 'Bitcoin',
          symbol: 'BTC',
          amount: 1.0,
          priceUsd: 50000.0,
          changePercent24h: 5.0,
          icon: Icons.currency_bitcoin,
          iconColor: Colors.orange,
        );

        expect(holding1, equals(holding2));
        expect(holding1.hashCode, equals(holding2.hashCode));
      });

      test('should not be equal when id is different', () {
        final holding1 = holding;
        final holding2 = holding.copyWith(id: 'ethereum');

        expect(holding1, isNot(equals(holding2)));
      });

      test('should not be equal when amount is different', () {
        final holding1 = holding;
        final holding2 = holding.copyWith(amount: 1.0);

        expect(holding1, isNot(equals(holding2)));
      });

      test('should not be equal when price is different', () {
        final holding1 = holding;
        final holding2 = holding.copyWith(priceUsd: 60000.0);

        expect(holding1, isNot(equals(holding2)));
      });

      test('should not be equal when change percent is different', () {
        final holding1 = holding;
        final holding2 = holding.copyWith(changePercent24h: 10.0);

        expect(holding1, isNot(equals(holding2)));
      });
    });

    group('Edge Cases', () {
      test('should handle very small amounts', () {
        final tinyHolding = holding.copyWith(amount: 0.00000001);
        expect(tinyHolding.valueUsd, 0.0005);
      });

      test('should handle very large prices', () {
        final expensiveHolding = holding.copyWith(priceUsd: 1000000.0);
        expect(expensiveHolding.valueUsd, 500000.0);
      });

      test('should handle extreme positive change', () {
        final extremeChange = holding.copyWith(changePercent24h: 1000.0);
        expect(extremeChange.changeUsd, 250000.0);
      });

      test('should handle extreme negative change', () {
        final extremeDrop = holding.copyWith(changePercent24h: -99.9);
        expect(extremeDrop.changeUsd, closeTo(-24975.0, 0.1));
      });
    });
  });
}

// Helper extension for copying PortfolioHolding
extension PortfolioHoldingCopyWith on PortfolioHolding {
  PortfolioHolding copyWith({
    String? id,
    String? name,
    String? symbol,
    double? amount,
    double? priceUsd,
    double? changePercent24h,
    IconData? icon,
    Color? iconColor,
  }) {
    return PortfolioHolding(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      amount: amount ?? this.amount,
      priceUsd: priceUsd ?? this.priceUsd,
      changePercent24h: changePercent24h ?? this.changePercent24h,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
    );
  }
}
