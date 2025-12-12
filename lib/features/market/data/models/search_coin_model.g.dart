// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_coin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponseModel _$SearchResponseModelFromJson(Map<String, dynamic> json) =>
    SearchResponseModel(
      coins: (json['coins'] as List<dynamic>)
          .map((e) => SearchCoinModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchResponseModelToJson(
        SearchResponseModel instance) =>
    <String, dynamic>{
      'coins': instance.coins,
    };

SearchCoinModel _$SearchCoinModelFromJson(Map<String, dynamic> json) =>
    SearchCoinModel(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt(),
      thumb: json['thumb'] as String?,
      small: json['small'] as String?,
      large: json['large'] as String?,
    );

Map<String, dynamic> _$SearchCoinModelToJson(SearchCoinModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symbol': instance.symbol,
      'market_cap_rank': instance.marketCapRank,
      'thumb': instance.thumb,
      'small': instance.small,
      'large': instance.large,
    };
