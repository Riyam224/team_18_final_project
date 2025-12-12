import 'package:json_annotation/json_annotation.dart';
import 'package:team_18_final_project/features/market/domain/entities/coin_details.dart';

part 'coin_details_model.g.dart';

/// Data model for detailed coin information from CoinGecko API
/// Maps JSON response to Dart object and converts to domain entity
@JsonSerializable()
class CoinDetailsModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'symbol')
  final String symbol;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'image')
  final CoinImageModel? image;

  @JsonKey(name: 'market_data')
  final MarketDataModel? marketData;

  @JsonKey(name: 'market_cap_rank')
  final int? marketCapRank;

  CoinDetailsModel({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.marketData,
    this.marketCapRank,
  });

  factory CoinDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$CoinDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoinDetailsModelToJson(this);

  /// Converts data model to domain entity
  CoinDetailsEntity toEntity() {
    return CoinDetailsEntity(
      id: id,
      symbol: symbol.toUpperCase(),
      name: name,
      image: image?.large ?? image?.small ?? image?.thumb,
      currentPrice: marketData?.currentPrice?.usd ?? 0.0,
      marketCapRank: marketCapRank,
      marketCap: marketData?.marketCap?.usd,
      totalVolume: marketData?.totalVolume?.usd,
      priceChangePercentage24h: marketData?.priceChangePercentage24h,
      priceChange24h: marketData?.priceChange24h,
      circulatingSupply: marketData?.circulatingSupply,
      totalSupply: marketData?.totalSupply,
      ath: marketData?.ath?.usd,
      atl: marketData?.atl?.usd,
    );
  }
}

@JsonSerializable()
class CoinImageModel {
  @JsonKey(name: 'thumb')
  final String? thumb;

  @JsonKey(name: 'small')
  final String? small;

  @JsonKey(name: 'large')
  final String? large;

  CoinImageModel({
    this.thumb,
    this.small,
    this.large,
  });

  factory CoinImageModel.fromJson(Map<String, dynamic> json) =>
      _$CoinImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoinImageModelToJson(this);
}

@JsonSerializable()
class MarketDataModel {
  @JsonKey(name: 'current_price')
  final PriceModel? currentPrice;

  @JsonKey(name: 'market_cap')
  final PriceModel? marketCap;

  @JsonKey(name: 'total_volume')
  final PriceModel? totalVolume;

  @JsonKey(name: 'price_change_24h')
  final double? priceChange24h;

  @JsonKey(name: 'price_change_percentage_24h')
  final double? priceChangePercentage24h;

  @JsonKey(name: 'circulating_supply')
  final double? circulatingSupply;

  @JsonKey(name: 'total_supply')
  final double? totalSupply;

  @JsonKey(name: 'ath')
  final PriceModel? ath;

  @JsonKey(name: 'atl')
  final PriceModel? atl;

  MarketDataModel({
    this.currentPrice,
    this.marketCap,
    this.totalVolume,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.circulatingSupply,
    this.totalSupply,
    this.ath,
    this.atl,
  });

  factory MarketDataModel.fromJson(Map<String, dynamic> json) =>
      _$MarketDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MarketDataModelToJson(this);
}

@JsonSerializable()
class PriceModel {
  @JsonKey(name: 'usd')
  final double? usd;

  PriceModel({this.usd});

  factory PriceModel.fromJson(Map<String, dynamic> json) =>
      _$PriceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PriceModelToJson(this);
}
