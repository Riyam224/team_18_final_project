import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/portfolio/presentation/portfolio_utils/app_portfolio_colors.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';

void main() {
  group('AppPortfolioColors Tests', () {
    group('getCryptoColor()', () {
      test('should return Bitcoin color for bitcoin id', () {
        expect(
          AppPortfolioColors.getCryptoColor('bitcoin'),
          AppColors.accentPurple,
        );
      });

      test('should return Bitcoin color for btc symbol', () {
        expect(
          AppPortfolioColors.getCryptoColor('btc'),
          AppColors.accentPurple,
        );
      });

      test('should return Ethereum color for ethereum id', () {
        expect(
          AppPortfolioColors.getCryptoColor('ethereum'),
          AppColors.accentCyan,
        );
      });

      test('should return Ethereum color for eth symbol', () {
        expect(
          AppPortfolioColors.getCryptoColor('eth'),
          AppColors.accentCyan,
        );
      });

      test('should return Litecoin color for litecoin id', () {
        expect(
          AppPortfolioColors.getCryptoColor('litecoin'),
          AppColors.accentCoral,
        );
      });

      test('should return Litecoin color for ltc symbol', () {
        expect(
          AppPortfolioColors.getCryptoColor('ltc'),
          AppColors.accentCoral,
        );
      });

      test('should return Cardano color for cardano id', () {
        expect(
          AppPortfolioColors.getCryptoColor('cardano'),
          AppColors.cryptoCardano,
        );
      });

      test('should return Ripple color for ripple id', () {
        expect(
          AppPortfolioColors.getCryptoColor('ripple'),
          AppColors.cryptoRipple,
        );
      });

      test('should return Polkadot color for polkadot id', () {
        expect(
          AppPortfolioColors.getCryptoColor('polkadot'),
          AppColors.cryptoPolkadot,
        );
      });

      test('should return Binance Coin color for binancecoin id', () {
        expect(
          AppPortfolioColors.getCryptoColor('binancecoin'),
          AppColors.cryptoBinance,
        );
      });

      test('should return Solana color for solana id', () {
        expect(
          AppPortfolioColors.getCryptoColor('solana'),
          AppColors.cryptoSolana,
        );
      });

      test('should return Dogecoin color for dogecoin id', () {
        expect(
          AppPortfolioColors.getCryptoColor('dogecoin'),
          AppColors.cryptoDogecoin,
        );
      });

      test('should return Polygon color for matic-network id', () {
        expect(
          AppPortfolioColors.getCryptoColor('matic-network'),
          AppColors.cryptoPolygon,
        );
      });

      test('should return Polygon color for polygon id', () {
        expect(
          AppPortfolioColors.getCryptoColor('polygon'),
          AppColors.cryptoPolygon,
        );
      });

      test('should return default gray color for unknown id', () {
        expect(
          AppPortfolioColors.getCryptoColor('unknown'),
          AppColors.cryptoDefault,
        );
      });

      test('should be case insensitive', () {
        expect(
          AppPortfolioColors.getCryptoColor('BITCOIN'),
          AppColors.accentPurple,
        );
        expect(
          AppPortfolioColors.getCryptoColor('BitCoin'),
          AppColors.accentPurple,
        );
        expect(
          AppPortfolioColors.getCryptoColor('BTC'),
          AppColors.accentPurple,
        );
      });

      test('should handle empty string', () {
        expect(
          AppPortfolioColors.getCryptoColor(''),
          AppColors.cryptoDefault,
        );
      });

      test('should handle whitespace', () {
        expect(
          AppPortfolioColors.getCryptoColor('   '),
          AppColors.cryptoDefault,
        );
      });
    });

    group('getCryptoIcon()', () {
      test('should return currency_bitcoin icon for bitcoin', () {
        expect(
          AppPortfolioColors.getCryptoIcon('bitcoin'),
          Icons.currency_bitcoin,
        );
      });

      test('should return token icon for ethereum', () {
        expect(
          AppPortfolioColors.getCryptoIcon('ethereum'),
          Icons.token,
        );
      });

      test('should return currency_exchange icon for litecoin', () {
        expect(
          AppPortfolioColors.getCryptoIcon('litecoin'),
          Icons.currency_exchange,
        );
      });

      test('should return account_balance_wallet icon for cardano', () {
        expect(
          AppPortfolioColors.getCryptoIcon('cardano'),
          Icons.account_balance_wallet,
        );
      });

      test('should return waves icon for ripple', () {
        expect(
          AppPortfolioColors.getCryptoIcon('ripple'),
          Icons.waves,
        );
      });

      test('should return circle_outlined icon for polkadot', () {
        expect(
          AppPortfolioColors.getCryptoIcon('polkadot'),
          Icons.circle_outlined,
        );
      });

      test('should return paid icon for binancecoin', () {
        expect(
          AppPortfolioColors.getCryptoIcon('binancecoin'),
          Icons.paid,
        );
      });

      test('should return flash_on icon for solana', () {
        expect(
          AppPortfolioColors.getCryptoIcon('solana'),
          Icons.flash_on,
        );
      });

      test('should return pets icon for dogecoin', () {
        expect(
          AppPortfolioColors.getCryptoIcon('dogecoin'),
          Icons.pets,
        );
      });

      test('should return hexagon_outlined icon for polygon', () {
        expect(
          AppPortfolioColors.getCryptoIcon('polygon'),
          Icons.hexagon_outlined,
        );
      });

      test('should return monetization_on icon for unknown crypto', () {
        expect(
          AppPortfolioColors.getCryptoIcon('unknown-crypto'),
          Icons.monetization_on,
        );
      });

      test('should be case insensitive for icons', () {
        expect(
          AppPortfolioColors.getCryptoIcon('BITCOIN'),
          Icons.currency_bitcoin,
        );
        expect(
          AppPortfolioColors.getCryptoIcon('Ethereum'),
          Icons.token,
        );
      });

      test('should handle symbol variations', () {
        expect(
          AppPortfolioColors.getCryptoIcon('btc'),
          Icons.currency_bitcoin,
        );
        expect(
          AppPortfolioColors.getCryptoIcon('eth'),
          Icons.token,
        );
        expect(
          AppPortfolioColors.getCryptoIcon('ltc'),
          Icons.currency_exchange,
        );
      });
    });

    group('Color consistency', () {
      test('all defined cryptocurrencies should have both color and icon', () {
        final cryptoIds = [
          'bitcoin',
          'ethereum',
          'litecoin',
          'cardano',
          'ripple',
          'polkadot',
          'binancecoin',
          'solana',
          'dogecoin',
          'polygon',
        ];

        for (final id in cryptoIds) {
          final color = AppPortfolioColors.getCryptoColor(id);
          final icon = AppPortfolioColors.getCryptoIcon(id);

          // Should not return default values
          expect(color, isNot(equals(AppColors.cryptoDefault)),
              reason: '$id should have a specific color');
          expect(icon, isNot(equals(Icons.monetization_on)),
              reason: '$id should have a specific icon');
        }
      });

      test('symbols should map to same colors as full names', () {
        final mappings = {
          'bitcoin': 'btc',
          'ethereum': 'eth',
          'litecoin': 'ltc',
        };

        mappings.forEach((fullName, symbol) {
          expect(
            AppPortfolioColors.getCryptoColor(fullName),
            AppPortfolioColors.getCryptoColor(symbol),
            reason: '$fullName and $symbol should have same color',
          );
          expect(
            AppPortfolioColors.getCryptoIcon(fullName),
            AppPortfolioColors.getCryptoIcon(symbol),
            reason: '$fullName and $symbol should have same icon',
          );
        });
      });
    });
  });
}
