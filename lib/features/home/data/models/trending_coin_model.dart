import 'package:json_annotation/json_annotation.dart';

part 'trending_coin_model.g.dart';

@JsonSerializable()
class TrendingCoinsModel {
  @JsonKey(name: 'coins')
  final List<TrendingCoinItem> coins;

  TrendingCoinsModel({required this.coins});

  factory TrendingCoinsModel.fromJson(Map<String, dynamic> json) =>
      _$TrendingCoinsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingCoinsModelToJson(this);
}

@JsonSerializable()
class TrendingCoinItem {
  @JsonKey(name: 'item')
  final TrendingCoin item;

  TrendingCoinItem({required this.item});

  factory TrendingCoinItem.fromJson(Map<String, dynamic> json) =>
      _$TrendingCoinItemFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingCoinItemToJson(this);
}

@JsonSerializable()
class TrendingCoin {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'coin_id')
  final int coinId;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'symbol')
  final String symbol;

  @JsonKey(name: 'thumb')
  final String thumb;

  @JsonKey(name: 'small')
  final String small;

  @JsonKey(name: 'large')
  final String large;

  @JsonKey(name: 'slug')
  final String slug;

  @JsonKey(name: 'price_btc')
  final double priceBtc;

  @JsonKey(name: 'score')
  final int score;

  @JsonKey(name: 'data')
  final TrendingCoinData data;

  TrendingCoin({
    required this.id,
    required this.coinId,
    required this.name,
    required this.symbol,
    required this.thumb,
    required this.small,
    required this.large,
    required this.slug,
    required this.priceBtc,
    required this.score,
    required this.data,
  });

  factory TrendingCoin.fromJson(Map<String, dynamic> json) =>
      _$TrendingCoinFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingCoinToJson(this);
}

@JsonSerializable()
class TrendingCoinData {
  @JsonKey(name: 'price')
  final dynamic price;

  @JsonKey(name: 'price_btc')
  final dynamic priceBtc;

  @JsonKey(name: 'price_change_percentage_24h')
  final Map<String, dynamic>? priceChangePercentage24h;

  @JsonKey(name: 'market_cap')
  final dynamic marketCap;

  @JsonKey(name: 'total_volume')
  final dynamic totalVolume;

  TrendingCoinData({
    required this.price,
    required this.priceBtc,
    this.priceChangePercentage24h,
    required this.marketCap,
    required this.totalVolume,
  });

  factory TrendingCoinData.fromJson(Map<String, dynamic> json) =>
      _$TrendingCoinDataFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingCoinDataToJson(this);
}
