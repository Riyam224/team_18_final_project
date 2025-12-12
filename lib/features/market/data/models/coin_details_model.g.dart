// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'coin_details_model.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// CoinDetailsModel _$CoinDetailsModelFromJson(Map<String, dynamic> json) =>
//     CoinDetailsModel(
//       id: json['id'] as String,
//       symbol: json['symbol'] as String,
//       name: json['name'] as String,
//       image: json['image'] == null
//           ? null
//           : CoinImageModel.fromJson(json['image'] as Map<String, dynamic>),
//       marketData: json['market_data'] == null
//           ? null
//           : MarketDataModel.fromJson(
//               json['market_data'] as Map<String, dynamic>),
//       marketCapRank: (json['market_cap_rank'] as num?)?.toInt(),
//     );

// Map<String, dynamic> _$CoinDetailsModelToJson(CoinDetailsModel instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'symbol': instance.symbol,
//       'name': instance.name,
//       'image': instance.image,
//       'market_data': instance.marketData,
//       'market_cap_rank': instance.marketCapRank,
//     };

// CoinImageModel _$CoinImageModelFromJson(Map<String, dynamic> json) =>
//     CoinImageModel(
//       thumb: json['thumb'] as String?,
//       small: json['small'] as String?,
//       large: json['large'] as String?,
//     );

// Map<String, dynamic> _$CoinImageModelToJson(CoinImageModel instance) =>
//     <String, dynamic>{
//       'thumb': instance.thumb,
//       'small': instance.small,
//       'large': instance.large,
//     };

// MarketDataModel _$MarketDataModelFromJson(Map<String, dynamic> json) =>
//     MarketDataModel(
//       currentPrice: json['current_price'] == null
//           ? null
//           : PriceModel.fromJson(json['current_price'] as Map<String, dynamic>),
//       marketCap: json['market_cap'] == null
//           ? null
//           : PriceModel.fromJson(json['market_cap'] as Map<String, dynamic>),
//       totalVolume: json['total_volume'] == null
//           ? null
//           : PriceModel.fromJson(json['total_volume'] as Map<String, dynamic>),
//       priceChange24h: (json['price_change_24h'] as num?)?.toDouble(),
//       priceChangePercentage24h:
//           (json['price_change_percentage_24h'] as num?)?.toDouble(),
//       circulatingSupply: (json['circulating_supply'] as num?)?.toDouble(),
//       totalSupply: (json['total_supply'] as num?)?.toDouble(),
//       ath: json['ath'] == null
//           ? null
//           : PriceModel.fromJson(json['ath'] as Map<String, dynamic>),
//       atl: json['atl'] == null
//           ? null
//           : PriceModel.fromJson(json['atl'] as Map<String, dynamic>),
//     );

// Map<String, dynamic> _$MarketDataModelToJson(MarketDataModel instance) =>
//     <String, dynamic>{
//       'current_price': instance.currentPrice,
//       'market_cap': instance.marketCap,
//       'total_volume': instance.totalVolume,
//       'price_change_24h': instance.priceChange24h,
//       'price_change_percentage_24h': instance.priceChangePercentage24h,
//       'circulating_supply': instance.circulatingSupply,
//       'total_supply': instance.totalSupply,
//       'ath': instance.ath,
//       'atl': instance.atl,
//     };

// PriceModel _$PriceModelFromJson(Map<String, dynamic> json) => PriceModel(
//       usd: (json['usd'] as num?)?.toDouble(),
//     );

// Map<String, dynamic> _$PriceModelToJson(PriceModel instance) =>
//     <String, dynamic>{
//       'usd': instance.usd,
//     };
