import 'package:equatable/equatable.dart';

class TopGainerEntity extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final double currentPrice;
  final double priceChangePercentage24h;

  const TopGainerEntity({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.currentPrice,
    required this.priceChangePercentage24h,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        symbol,
        imageUrl,
        currentPrice,
        priceChangePercentage24h,
      ];
}
