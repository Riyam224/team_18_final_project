import 'package:json_annotation/json_annotation.dart';

part 'global_data_model.g.dart';

@JsonSerializable()
class GlobalDataModel {
  @JsonKey(name: 'data')
  final GlobalData data;

  GlobalDataModel({required this.data});

  factory GlobalDataModel.fromJson(Map<String, dynamic> json) =>
      _$GlobalDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$GlobalDataModelToJson(this);
}

@JsonSerializable()
class GlobalData {
  @JsonKey(name: 'active_cryptocurrencies')
  final int activeCryptocurrencies;

  @JsonKey(name: 'total_market_cap')
  final Map<String, double> totalMarketCap;

  @JsonKey(name: 'total_volume')
  final Map<String, double> totalVolume;

  @JsonKey(name: 'market_cap_percentage')
  final Map<String, double> marketCapPercentage;

  @JsonKey(name: 'market_cap_change_percentage_24h_usd')
  final double marketCapChangePercentage24hUsd;

  GlobalData({
    required this.activeCryptocurrencies,
    required this.totalMarketCap,
    required this.totalVolume,
    required this.marketCapPercentage,
    required this.marketCapChangePercentage24hUsd,
  });

  factory GlobalData.fromJson(Map<String, dynamic> json) =>
      _$GlobalDataFromJson(json);

  Map<String, dynamic> toJson() => _$GlobalDataToJson(this);
}
