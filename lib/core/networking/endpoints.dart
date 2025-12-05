class Endpoints {
  static const global = "/global";
  static const trending = "/search/trending";
  static const topMarkets =
      "/coins/markets?vs_currency=usd&order=market_cap_desc";

  static String marketList(int page) =>
      "/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=$page";

  static String search(String keyword) => "/search?query=$keyword";

  static String coin(String id) => "/coins/$id";
  static String marketChart(String id, String days) =>
      "/coins/$id/market_chart?vs_currency=usd&days=$days";

  static String simplePrice(String ids) =>
      "/simple/price?ids=$ids&vs_currencies=usd&include_24hr_change=true";
}
