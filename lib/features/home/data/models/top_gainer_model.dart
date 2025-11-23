// Imports the json_annotation package for JSON serialization annotations
import 'package:json_annotation/json_annotation.dart';

// Links to the generated file that contains serialization code
part 'top_gainer_model.g.dart';

/// Model class representing a cryptocurrency that has gained significant value
/// Contains comprehensive market data for coins with highest percentage increases
@JsonSerializable()
class TopGainerModel {
  /// Unique identifier for the cryptocurrency (e.g., 'bitcoin', 'ethereum')
  @JsonKey(name: 'id')
  final String id;

  /// Trading symbol/ticker for the cryptocurrency (e.g., 'BTC', 'ETH')
  @JsonKey(name: 'symbol')
  final String symbol;

  /// Full name of the cryptocurrency (e.g., 'Bitcoin', 'Ethereum')
  @JsonKey(name: 'name')
  final String name;

  /// URL to the cryptocurrency's logo/icon image
  @JsonKey(name: 'image')
  final String image;

  /// Current trading price in the selected fiat currency (e.g., USD)
  @JsonKey(name: 'current_price')
  final double currentPrice;

  /// Total market capitalization (price × circulating supply)
  @JsonKey(name: 'market_cap')
  final double marketCap;

  /// Rank by market capitalization (1 = highest market cap)
  /// Nullable as some new coins may not have a rank yet
  @JsonKey(name: 'market_cap_rank')
  final int? marketCapRank;

  /// Market cap if max supply is in circulation (max_supply × current_price)
  /// Nullable as not all coins have a max supply
  @JsonKey(name: 'fully_diluted_valuation')
  final double? fullyDilutedValuation;

  /// Total trading volume over the last 24 hours
  @JsonKey(name: 'total_volume')
  final double totalVolume;

  /// Highest price reached in the last 24 hours
  /// Nullable as data may not always be available
  @JsonKey(name: 'high_24h')
  final double? high24h;

  /// Lowest price reached in the last 24 hours
  /// Nullable as data may not always be available
  @JsonKey(name: 'low_24h')
  final double? low24h;

  /// Absolute price change in the last 24 hours (in fiat currency)
  /// Nullable as data may not always be available
  @JsonKey(name: 'price_change_24h')
  final double? priceChange24h;

  /// Percentage change in price over the last 24 hours
  /// This is typically the key metric for identifying "top gainers"
  @JsonKey(name: 'price_change_percentage_24h')
  final double? priceChangePercentage24h;

  /// Absolute change in market cap over the last 24 hours
  /// Nullable as data may not always be available
  @JsonKey(name: 'market_cap_change_24h')
  final double? marketCapChange24h;

  /// Percentage change in market cap over the last 24 hours
  /// Nullable as data may not always be available
  @JsonKey(name: 'market_cap_change_percentage_24h')
  final double? marketCapChangePercentage24h;

  /// Number of coins currently in circulation and available for trading
  /// Nullable as some coins may not report this data
  @JsonKey(name: 'circulating_supply')
  final double? circulatingSupply;

  /// Total number of coins that currently exist (mined/minted)
  /// Nullable as some coins may not report this data
  @JsonKey(name: 'total_supply')
  final double? totalSupply;

  /// Maximum number of coins that will ever exist
  /// Nullable as some coins have unlimited supply (e.g., Ethereum)
  @JsonKey(name: 'max_supply')
  final double? maxSupply;

  /// All-Time High price - the highest price ever reached
  /// Nullable as new coins may not have sufficient history
  @JsonKey(name: 'ath')
  final double? ath;

  /// Percentage change from the all-time high price to current price
  /// Negative value shows how far below ATH the current price is
  @JsonKey(name: 'ath_change_percentage')
  final double? athChangePercentage;

  /// Date when the all-time high was reached (ISO 8601 format)
  /// Nullable as new coins may not have sufficient history
  @JsonKey(name: 'ath_date')
  final String? athDate;

  /// All-Time Low price - the lowest price ever reached
  /// Nullable as new coins may not have sufficient history
  @JsonKey(name: 'atl')
  final double? atl;

  /// Percentage change from the all-time low price to current price
  /// Positive value shows how much the price has increased since ATL
  @JsonKey(name: 'atl_change_percentage')
  final double? atlChangePercentage;

  /// Date when the all-time low was reached (ISO 8601 format)
  /// Nullable as new coins may not have sufficient history
  @JsonKey(name: 'atl_date')
  final String? atlDate;

  /// Timestamp of when this data was last updated (ISO 8601 format)
  @JsonKey(name: 'last_updated')
  final String lastUpdated;

  /// Constructor with all cryptocurrency market data fields
  /// Required fields are essential data, optional fields may not always be available from API
  TopGainerModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    this.marketCapRank,
    this.fullyDilutedValuation,
    required this.totalVolume,
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
    required this.lastUpdated,
  });

  /// Factory constructor to create TopGainerModel from JSON
  /// Used when deserializing API response from CoinGecko markets endpoint
  factory TopGainerModel.fromJson(Map<String, dynamic> json) =>
      _$TopGainerModelFromJson(json);

  /// Converts this model to JSON format
  /// Used when serializing data for storage or transmission
  Map<String, dynamic> toJson() => _$TopGainerModelToJson(this);
}
