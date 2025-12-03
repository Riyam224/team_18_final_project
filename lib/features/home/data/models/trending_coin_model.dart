// Imports the json_annotation package for JSON serialization annotations
import 'package:json_annotation/json_annotation.dart';

// Links to the generated file that contains serialization code
part 'trending_coin_model.g.dart';

/// Top-level model representing the API response for trending cryptocurrencies
/// Wraps a list of trending coins from CoinGecko's trending endpoint
@JsonSerializable()
class TrendingCoinsModel {
  /// List of trending cryptocurrency items currently popular on CoinGecko
  @JsonKey(name: 'coins')
  final List<TrendingCoinItem> coins;

  /// Constructor requiring the list of trending coins
  TrendingCoinsModel({required this.coins});

  /// Factory constructor to create TrendingCoinsModel from JSON
  /// Used when deserializing API response
  factory TrendingCoinsModel.fromJson(Map<String, dynamic> json) =>
      _$TrendingCoinsModelFromJson(json);

  /// Converts this model to JSON format
  /// Used when serializing data for storage or transmission
  Map<String, dynamic> toJson() => _$TrendingCoinsModelToJson(this);
}

/// Wrapper class for a single trending coin item
/// The API returns coins nested in an 'item' object, this class handles that structure
@JsonSerializable()
class TrendingCoinItem {
  /// The actual trending coin data nested inside the 'item' field
  @JsonKey(name: 'item')
  final TrendingCoin item;

  /// Constructor requiring the trending coin item
  TrendingCoinItem({required this.item});

  /// Factory constructor to create TrendingCoinItem from JSON
  /// Used when deserializing each item in the trending coins list
  factory TrendingCoinItem.fromJson(Map<String, dynamic> json) =>
      _$TrendingCoinItemFromJson(json);

  /// Converts this model to JSON format
  Map<String, dynamic> toJson() => _$TrendingCoinItemToJson(this);
}

/// Model representing a single trending cryptocurrency with basic info and market data
/// Contains identification, imagery, and nested detailed market data
@JsonSerializable()
class TrendingCoin {
  /// Unique identifier for the cryptocurrency (e.g., 'bitcoin', 'ethereum')
  @JsonKey(name: 'id')
  final String id;

  /// Numeric ID used by CoinGecko's internal system
  @JsonKey(name: 'coin_id')
  final int coinId;

  /// Full name of the cryptocurrency (e.g., 'Bitcoin', 'Ethereum')
  @JsonKey(name: 'name')
  final String name;

  /// Trading symbol/ticker for the cryptocurrency (e.g., 'BTC', 'ETH')
  @JsonKey(name: 'symbol')
  final String symbol;

  /// URL to thumbnail-sized coin image (smallest size)
  @JsonKey(name: 'thumb')
  final String thumb;

  /// URL to small-sized coin image (medium size)
  @JsonKey(name: 'small')
  final String small;

  /// URL to large-sized coin image (largest size)
  @JsonKey(name: 'large')
  final String large;

  /// URL-friendly slug identifier for the coin (used in web URLs)
  @JsonKey(name: 'slug')
  final String slug;

  /// Current price of the coin in Bitcoin (BTC)
  /// Useful for comparing value against Bitcoin
  @JsonKey(name: 'price_btc')
  final double priceBtc;

  /// Trending score indicating popularity (higher = more trending)
  /// Based on search volume and other engagement metrics on CoinGecko
  @JsonKey(name: 'score')
  final int score;

  /// Nested object containing detailed market data for this trending coin
  @JsonKey(name: 'data')
  final TrendingCoinData data;

  /// Constructor with all trending coin identification and market data fields
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

  /// Factory constructor to create TrendingCoin from JSON
  /// Used when deserializing trending coin data from API response
  factory TrendingCoin.fromJson(Map<String, dynamic> json) =>
      _$TrendingCoinFromJson(json);

  /// Converts this model to JSON format
  Map<String, dynamic> toJson() => _$TrendingCoinToJson(this);
}

/// Model containing detailed market data for a trending cryptocurrency
/// Uses dynamic types as the API may return different formats (strings or numbers)
@JsonSerializable()
class TrendingCoinData {
  /// Current price of the coin, can be a string or number from API
  /// Dynamic type handles varying API response formats
  @JsonKey(name: 'price')
  final dynamic price;

  /// Current price in Bitcoin (BTC), can be a string or number from API
  /// Dynamic type handles varying API response formats
  @JsonKey(name: 'price_btc')
  final dynamic priceBtc;

  /// Map of price change percentages over 24h in different currencies
  /// Key: currency code, Value: percentage change
  /// Nullable as this data may not always be available for all trending coins
  @JsonKey(name: 'price_change_percentage_24h')
  final Map<String, dynamic>? priceChangePercentage24h;

  /// Market capitalization, can be a string or number from API
  /// Dynamic type handles varying API response formats
  @JsonKey(name: 'market_cap')
  final dynamic marketCap;

  /// Total trading volume, can be a string or number from API
  /// Dynamic type handles varying API response formats
  @JsonKey(name: 'total_volume')
  final dynamic totalVolume;

  /// Constructor with market data fields
  /// Dynamic types allow flexibility in handling different API response formats
  TrendingCoinData({
    required this.price,
    required this.priceBtc,
    this.priceChangePercentage24h,
    required this.marketCap,
    required this.totalVolume,
  });

  /// Factory constructor to create TrendingCoinData from JSON
  /// Used when deserializing nested market data
  factory TrendingCoinData.fromJson(Map<String, dynamic> json) =>
      _$TrendingCoinDataFromJson(json);

  /// Converts this model to JSON format
  Map<String, dynamic> toJson() => _$TrendingCoinDataToJson(this);
}
