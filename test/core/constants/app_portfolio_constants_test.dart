import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/portfolio/presentation/portfolio_utils/app_portfolio_constants.dart';

void main() {
  group('AppPortfolioConstants Tests', () {
    group('monthIndexToDays', () {
      test('should map month index 0 to 30 days', () {
        expect(AppPortfolioConstants.monthIndexToDays[0], 30);
      });

      test('should map month index 1 to 60 days', () {
        expect(AppPortfolioConstants.monthIndexToDays[1], 60);
      });

      test('should map month index 2 to 90 days', () {
        expect(AppPortfolioConstants.monthIndexToDays[2], 90);
      });

      test('should map month index 3 to 120 days', () {
        expect(AppPortfolioConstants.monthIndexToDays[3], 120);
      });

      test('should map month index 4 to 150 days', () {
        expect(AppPortfolioConstants.monthIndexToDays[4], 150);
      });

      test('should map month index 5 to 180 days', () {
        expect(AppPortfolioConstants.monthIndexToDays[5], 180);
      });

      test('should have 6 month mappings', () {
        expect(AppPortfolioConstants.monthIndexToDays.length, 6);
      });

      test('should have consecutive 30-day increments', () {
        for (int i = 0; i < 6; i++) {
          expect(
            AppPortfolioConstants.monthIndexToDays[i],
            (i + 1) * 30,
            reason: 'Month index $i should map to ${(i + 1) * 30} days',
          );
        }
      });

      test('should return null for invalid month index', () {
        expect(AppPortfolioConstants.monthIndexToDays[6], null);
        expect(AppPortfolioConstants.monthIndexToDays[-1], null);
        expect(AppPortfolioConstants.monthIndexToDays[100], null);
      });

      test('should be immutable (const map)', () {
        expect(
          () => (AppPortfolioConstants.monthIndexToDays as dynamic)[10] = 300,
          throwsUnsupportedError,
        );
      });
    });

    group('defaultMonthIndex', () {
      test('should be index 1 (December/60 days)', () {
        expect(AppPortfolioConstants.defaultMonthIndex, 1);
      });

      test('should map to valid days value', () {
        final days = AppPortfolioConstants
            .monthIndexToDays[AppPortfolioConstants.defaultMonthIndex];
        expect(days, isNotNull);
        expect(days, 60);
      });

      test('should be within valid range', () {
        expect(
            AppPortfolioConstants.defaultMonthIndex, greaterThanOrEqualTo(0));
        expect(AppPortfolioConstants.defaultMonthIndex, lessThan(6));
      });
    });

    group('String formatters', () {
      test('changeLabelSuffix should be "Today"', () {
        expect(AppPortfolioConstants.changeLabelSuffix, 'Today');
      });

      test('positivePrefix should be "+"', () {
        expect(AppPortfolioConstants.positivePrefix, '+');
      });

      test('percentSuffix should be "%"', () {
        expect(AppPortfolioConstants.percentSuffix, '%');
      });

      test('should have non-empty strings', () {
        expect(AppPortfolioConstants.changeLabelSuffix, isNotEmpty);
        expect(AppPortfolioConstants.positivePrefix, isNotEmpty);
        expect(AppPortfolioConstants.percentSuffix, isNotEmpty);
      });

      test('should have expected lengths', () {
        expect(AppPortfolioConstants.positivePrefix.length, 1);
        expect(AppPortfolioConstants.percentSuffix.length, 1);
        expect(AppPortfolioConstants.changeLabelSuffix.length, greaterThan(0));
      });
    });

    group('Integration with month selector', () {
      test('should provide valid time periods for all month indices', () {
        for (int i = 0; i < 6; i++) {
          final days = AppPortfolioConstants.monthIndexToDays[i];
          expect(days, isNotNull);
          expect(days, greaterThan(0));
          expect(days! % 30, 0, reason: 'Days should be multiple of 30');
        }
      });

      test('should calculate months correctly from days', () {
        AppPortfolioConstants.monthIndexToDays.forEach((index, days) {
          final months = days / 30;
          expect(months, index + 1);
        });
      });

      test('should support 1-6 months range', () {
        expect(AppPortfolioConstants.monthIndexToDays[0], 30); // 1 month
        expect(AppPortfolioConstants.monthIndexToDays[5], 180); // 6 months
      });
    });

    group('Formatter usage scenarios', () {
      test('should format positive percentage correctly', () {
        final formatted =
            '${AppPortfolioConstants.positivePrefix}5.0${AppPortfolioConstants.percentSuffix}';
        expect(formatted, '+5.0%');
      });

      test('should format negative percentage correctly', () {
        final formatted = '-3.5${AppPortfolioConstants.percentSuffix}';
        expect(formatted, '-3.5%');
      });

      test('should format change label correctly', () {
        final value = '+5.0%';
        final amount = '\$1,250.00';
        final label =
            '$value ($amount) ${AppPortfolioConstants.changeLabelSuffix}';
        expect(label, '+5.0% (\$1,250.00) Today');
      });
    });

    group('Constants immutability', () {
      test('monthIndexToDays should be const', () {
        const testMap = AppPortfolioConstants.monthIndexToDays;
        expect(testMap[0], 30);
      });

      test('defaultMonthIndex should be const', () {
        const testValue = AppPortfolioConstants.defaultMonthIndex;
        expect(testValue, 1);
      });

      test('string constants should be const', () {
        const prefix = AppPortfolioConstants.positivePrefix;
        const suffix = AppPortfolioConstants.percentSuffix;
        const label = AppPortfolioConstants.changeLabelSuffix;

        expect(prefix, '+');
        expect(suffix, '%');
        expect(label, 'Today');
      });
    });
  });
}
