import 'package:json_annotation/json_annotation.dart';
import 'package:team_18_final_project/features/market/domain/entities/market_coin.dart';

part 'market_coin_model.g.dart';

/// Data model for market coin from API
/// Maps JSON response to Dart object and converts to domain entity
@JsonSerializable()
class MarketCoinModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'symbol')
  final String symbol;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'current_price')
  final double? currentPrice;

  @JsonKey(name: 'market_cap')
  final double? marketCap;

  @JsonKey(name: 'market_cap_rank')
  final int? marketCapRank;

  @JsonKey(name: 'fully_diluted_valuation')
  final double? fullyDilutedValuation;

  @JsonKey(name: 'total_volume')
  final double? totalVolume;

  @JsonKey(name: 'high_24h')
  final double? high24h;

  @JsonKey(name: 'low_24h')
  final double? low24h;

  @JsonKey(name: 'price_change_24h')
  final double? priceChange24h;

  @JsonKey(name: 'price_change_percentage_24h')
  final double? priceChangePercentage24h;

  @JsonKey(name: 'market_cap_change_24h')
  final double? marketCapChange24h;

  @JsonKey(name: 'market_cap_change_percentage_24h')
  final double? marketCapChangePercentage24h;

  @JsonKey(name: 'circulating_supply')
  final double? circulatingSupply;

  @JsonKey(name: 'total_supply')
  final double? totalSupply;

  @JsonKey(name: 'max_supply')
  final double? maxSupply;

  @JsonKey(name: 'ath')
  final double? ath;

  @JsonKey(name: 'ath_change_percentage')
  final double? athChangePercentage;

  @JsonKey(name: 'ath_date')
  final DateTime? athDate;

  @JsonKey(name: 'atl')
  final double? atl;

  @JsonKey(name: 'atl_change_percentage')
  final double? atlChangePercentage;

  @JsonKey(name: 'atl_date')
  final DateTime? atlDate;

  @JsonKey(name: 'last_updated')
  final DateTime? lastUpdated;

  MarketCoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.fullyDilutedValuation,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.marketCapChange24h,
    this.marketCapChangePercentage24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
    this.lastUpdated,
  });

  factory MarketCoinModel.fromJson(Map<String, dynamic> json) =>
      _$MarketCoinModelFromJson(json);

  Map<String, dynamic> toJson() => _$MarketCoinModelToJson(this);

  /// Converts data model to domain entity
  MarketCoinEntity toEntity() {
    return MarketCoinEntity(
      id: id,
      symbol: symbol,
      name: name,
      image: image,
      currentPrice: currentPrice,
      marketCap: marketCap,
      marketCapRank: marketCapRank,
      totalVolume: totalVolume,
      high24h: high24h,
      low24h: low24h,
      priceChange24h: priceChange24h,
      priceChangePercentage24h: priceChangePercentage24h,
      marketCapChange24h: marketCapChange24h,
      marketCapChangePercentage24h: marketCapChangePercentage24h,
      circulatingSupply: circulatingSupply,
      totalSupply: totalSupply,
      maxSupply: maxSupply,
      ath: ath,
      athChangePercentage: athChangePercentage,
      athDate: athDate,
      atl: atl,
      atlChangePercentage: atlChangePercentage,
      atlDate: atlDate,
      lastUpdated: lastUpdated,
    );
  }
}
