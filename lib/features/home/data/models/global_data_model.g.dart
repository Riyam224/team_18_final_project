// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlobalDataModel _$GlobalDataModelFromJson(Map<String, dynamic> json) =>
    GlobalDataModel(
      data: GlobalData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GlobalDataModelToJson(GlobalDataModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

GlobalData _$GlobalDataFromJson(Map<String, dynamic> json) => GlobalData(
      activeCryptocurrencies: (json['active_cryptocurrencies'] as num).toInt(),
      totalMarketCap: (json['total_market_cap'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      totalVolume: (json['total_volume'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      marketCapPercentage:
          (json['market_cap_percentage'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      marketCapChangePercentage24hUsd:
          (json['market_cap_change_percentage_24h_usd'] as num).toDouble(),
    );

Map<String, dynamic> _$GlobalDataToJson(GlobalData instance) =>
    <String, dynamic>{
      'active_cryptocurrencies': instance.activeCryptocurrencies,
      'total_market_cap': instance.totalMarketCap,
      'total_volume': instance.totalVolume,
      'market_cap_percentage': instance.marketCapPercentage,
      'market_cap_change_percentage_24h_usd':
          instance.marketCapChangePercentage24hUsd,
    };
