// Imports the json_annotation package for JSON serialization annotations
import 'package:json_annotation/json_annotation.dart';

// Links to the generated file that contains serialization code
part 'global_data_model.g.dart';

/// Model class representing the API response wrapper for global cryptocurrency market data
/// This is the top-level response model from the CoinGecko global market data endpoint
@JsonSerializable()
class GlobalDataModel {
  /// The actual global market data nested inside the 'data' field of the API response
  @JsonKey(name: 'data')
  final GlobalData data;

  /// Constructor requiring the global market data
  GlobalDataModel({required this.data});

  /// Factory constructor to create GlobalDataModel from JSON
  /// Used when deserializing API responses
  factory GlobalDataModel.fromJson(Map<String, dynamic> json) =>
      _$GlobalDataModelFromJson(json);

  /// Converts this model to JSON format
  /// Used when serializing data for storage or API requests
  Map<String, dynamic> toJson() => _$GlobalDataModelToJson(this);
}

/// Model class containing comprehensive global cryptocurrency market statistics
/// Provides overview metrics for the entire crypto market
@JsonSerializable()
class GlobalData {
  /// Total number of active cryptocurrencies tracked by the platform
  @JsonKey(name: 'active_cryptocurrencies')
  final int activeCryptocurrencies;

  /// Total market capitalization across all cryptocurrencies in different fiat currencies
  /// Key: currency code (e.g., 'usd', 'eur'), Value: market cap in that currency
  @JsonKey(name: 'total_market_cap')
  final Map<String, double> totalMarketCap;

  /// Total 24-hour trading volume across all cryptocurrencies in different fiat currencies
  /// Key: currency code, Value: volume in that currency
  @JsonKey(name: 'total_volume')
  final Map<String, double> totalVolume;

  /// Market cap dominance percentage for major cryptocurrencies
  /// Key: cryptocurrency symbol (e.g., 'btc', 'eth'), Value: percentage of total market cap
  @JsonKey(name: 'market_cap_percentage')
  final Map<String, double> marketCapPercentage;

  /// Percentage change in total market cap over the last 24 hours (in USD)
  /// Positive values indicate market growth, negative indicate market decline
  @JsonKey(name: 'market_cap_change_percentage_24h_usd')
  final double marketCapChangePercentage24hUsd;

  /// Constructor requiring all global market data fields
  GlobalData({
    required this.activeCryptocurrencies,
    required this.totalMarketCap,
    required this.totalVolume,
    required this.marketCapPercentage,
    required this.marketCapChangePercentage24hUsd,
  });

  /// Factory constructor to create GlobalData from JSON
  /// Called by the generated code to deserialize API responses
  factory GlobalData.fromJson(Map<String, dynamic> json) =>
      _$GlobalDataFromJson(json);

  /// Converts this model to JSON format
  /// Called when serializing for storage or transmission
  Map<String, dynamic> toJson() => _$GlobalDataToJson(this);
}
