import 'package:json_annotation/json_annotation.dart';
import 'package:team_18_final_project/features/market/domain/entities/search_coin.dart';

part 'search_coin_model.g.dart';

/// Wrapper model for search API response
@JsonSerializable()
class SearchResponseModel {
  @JsonKey(name: 'coins')
  final List<SearchCoinModel> coins;

  SearchResponseModel({required this.coins});

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseModelToJson(this);
}

/// Data model for search coin from API
/// Maps JSON response to Dart object and converts to domain entity
@JsonSerializable()
class SearchCoinModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'symbol')
  final String symbol;

  @JsonKey(name: 'market_cap_rank')
  final int? marketCapRank;

  @JsonKey(name: 'thumb')
  final String? thumb;

  @JsonKey(name: 'small')
  final String? small;

  @JsonKey(name: 'large')
  final String? large;

  SearchCoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    this.marketCapRank,
    this.thumb,
    this.small,
    this.large,
  });

  factory SearchCoinModel.fromJson(Map<String, dynamic> json) =>
      _$SearchCoinModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchCoinModelToJson(this);

  /// Converts data model to domain entity
  SearchCoinEntity toEntity() {
    return SearchCoinEntity(
      id: id,
      name: name,
      symbol: symbol,
      marketCapRank: marketCapRank,
      thumb: thumb,
      small: small,
      large: large,
    );
  }
}
