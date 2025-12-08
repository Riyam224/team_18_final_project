class ApiBaseUrl {
  ApiBaseUrl._();
  static const String coingecko = 'https://api.coingecko.com/api/v3';
}

class ApiEndpoints {
  ApiEndpoints._();

  static const String simplePrice = '/simple/price';
  static const String marketChart = '/coins/{id}/market_chart';
}

class ApiQueryParams {
  ApiQueryParams._();

  static const String ids = 'ids';
  static const String vsCurrencies = 'vs_currencies';
  static const String include24hrChange = 'include_24hr_change';

  static const String vsCurrency = 'vs_currency';
  static const String days = 'days';
  static const String order = 'order';
  static const String perPage = 'per_page';
  static const String page = 'page';
}

class ApiPathParams {
  ApiPathParams._();
  static const String id = 'id';
}

class ApiDefaults {
  ApiDefaults._();

  static const String currency = 'usd';
  static const bool include24hrChange = true;
  static const int defaultDays = 7;
  static const int minDays = 1;
  static const int maxDays = 365;
  static const String orderByMarketCap = 'market_cap_desc';
  static const int defaultPerPage = 50;
}

class ApiHeaders {
  ApiHeaders._();

  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
}
