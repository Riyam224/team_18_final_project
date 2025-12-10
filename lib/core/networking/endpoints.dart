import 'package:team_18_final_project/core/constants/api_constants.dart';

class Endpoints {
  static const global = "/global";
  static const trendingCoinsList = "/search/trending";
  static const topGainers =
      "/coins/markets?${ApiQueryParams.vsCurrency}=${ApiDefaults.currency}&${ApiQueryParams.order}=${ApiDefaults.orderByMarketCap}";

  static String marketList(int page) =>
      "/coins/markets?${ApiQueryParams.vsCurrency}=${ApiDefaults.currency}&${ApiQueryParams.order}=${ApiDefaults.orderByMarketCap}&${ApiQueryParams.perPage}=${ApiDefaults.defaultPerPage}&${ApiQueryParams.page}=$page";

  static String search(String keyword) => "/search?query=$keyword";

  static String coin(String id) => "/coins/$id";
  static String marketChart(String id, String days) =>
      "/coins/$id/market_chart?${ApiQueryParams.vsCurrency}=${ApiDefaults.currency}&${ApiQueryParams.days}=$days";

  static String simplePrice(String ids) =>
      "/simple/price?${ApiQueryParams.ids}=$ids&${ApiQueryParams.vsCurrencies}=${ApiDefaults.currency}&${ApiQueryParams.include24hrChange}=true";
}
