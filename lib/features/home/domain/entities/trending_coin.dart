import 'package:equatable/equatable.dart';

class TrendingCoinEntity extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final String price;
  final double priceChangePercentage24h;

  const TrendingCoinEntity({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.priceChangePercentage24h,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        symbol,
        imageUrl,
        price,
        priceChangePercentage24h,
      ];
}
