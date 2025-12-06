// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_coin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendingCoinsModel _$TrendingCoinsModelFromJson(Map<String, dynamic> json) =>
    TrendingCoinsModel(
      coins: (json['coins'] as List<dynamic>)
          .map((e) => TrendingCoinItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrendingCoinsModelToJson(TrendingCoinsModel instance) =>
    <String, dynamic>{
      'coins': instance.coins,
    };

TrendingCoinItem _$TrendingCoinItemFromJson(Map<String, dynamic> json) =>
    TrendingCoinItem(
      item: TrendingCoin.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrendingCoinItemToJson(TrendingCoinItem instance) =>
    <String, dynamic>{
      'item': instance.item,
    };

TrendingCoin _$TrendingCoinFromJson(Map<String, dynamic> json) => TrendingCoin(
      id: json['id'] as String,
      coinId: (json['coin_id'] as num).toInt(),
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      thumb: json['thumb'] as String,
      small: json['small'] as String,
      large: json['large'] as String,
      slug: json['slug'] as String,
      priceBtc: (json['price_btc'] as num).toDouble(),
      score: (json['score'] as num).toInt(),
      data: TrendingCoinData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrendingCoinToJson(TrendingCoin instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coin_id': instance.coinId,
      'name': instance.name,
      'symbol': instance.symbol,
      'thumb': instance.thumb,
      'small': instance.small,
      'large': instance.large,
      'slug': instance.slug,
      'price_btc': instance.priceBtc,
      'score': instance.score,
      'data': instance.data,
    };

TrendingCoinData _$TrendingCoinDataFromJson(Map<String, dynamic> json) =>
    TrendingCoinData(
      price: json['price'],
      priceBtc: json['price_btc'],
      priceChangePercentage24h:
          json['price_change_percentage_24h'] as Map<String, dynamic>?,
      marketCap: json['market_cap'],
      totalVolume: json['total_volume'],
    );

Map<String, dynamic> _$TrendingCoinDataToJson(TrendingCoinData instance) =>
    <String, dynamic>{
      'price': instance.price,
      'price_btc': instance.priceBtc,
      'price_change_percentage_24h': instance.priceChangePercentage24h,
      'market_cap': instance.marketCap,
      'total_volume': instance.totalVolume,
    };
