import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/constants/api_constants.dart';

void main() {
  group('ApiBaseUrl', () {
    test('should have valid CoinGecko base URL', () {
      expect(ApiBaseUrl.coingecko, 'https://api.coingecko.com/api/v3');
      expect(ApiBaseUrl.coingecko, startsWith('https://'));
      expect(ApiBaseUrl.coingecko, contains('coingecko'));
    });
  });

  group('ApiEndpoints', () {
    test('should have valid endpoint paths', () {
      expect(ApiEndpoints.simplePrice, '/simple/price');
      expect(ApiEndpoints.marketChart, '/coins/{id}/market_chart');
    });

    test('endpoints should start with slash', () {
      expect(ApiEndpoints.simplePrice.startsWith('/'), true);
      expect(ApiEndpoints.marketChart.startsWith('/'), true);
    });
  });

  group('ApiQueryParams', () {
    test('should have correct query parameter names', () {
      expect(ApiQueryParams.ids, 'ids');
      expect(ApiQueryParams.vsCurrencies, 'vs_currencies');
      expect(ApiQueryParams.include24hrChange, 'include_24hr_change');
      expect(ApiQueryParams.vsCurrency, 'vs_currency');
      expect(ApiQueryParams.days, 'days');
      expect(ApiQueryParams.order, 'order');
      expect(ApiQueryParams.perPage, 'per_page');
      expect(ApiQueryParams.page, 'page');
    });
  });

  group('ApiPathParams', () {
    test('should have correct path parameter names', () {
      expect(ApiPathParams.id, 'id');
    });
  });

  group('ApiDefaults', () {
    test('should have sensible default values', () {
      expect(ApiDefaults.currency, 'usd');
      expect(ApiDefaults.include24hrChange, true);
      expect(ApiDefaults.defaultDays, 7);
      expect(ApiDefaults.minDays, 1);
      expect(ApiDefaults.maxDays, 365);
      expect(ApiDefaults.orderByMarketCap, 'market_cap_desc');
      expect(ApiDefaults.defaultPerPage, 50);
    });

    test('days range should be valid', () {
      expect(ApiDefaults.minDays, lessThanOrEqualTo(ApiDefaults.defaultDays));
      expect(ApiDefaults.defaultDays, lessThanOrEqualTo(ApiDefaults.maxDays));
      expect(ApiDefaults.minDays, greaterThan(0));
    });

    test('per page should be reasonable', () {
      expect(ApiDefaults.defaultPerPage, greaterThan(0));
      expect(ApiDefaults.defaultPerPage, lessThanOrEqualTo(100));
    });
  });

  group('ApiHeaders', () {
    test('should have correct header names', () {
      expect(ApiHeaders.contentType, 'Content-Type');
      expect(ApiHeaders.applicationJson, 'application/json');
    });
  });
}
