import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PortfolioHolding extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final double amount;
  final double priceUsd;
  final double changePercent24h;
  final IconData icon;
  final Color iconColor;

  const PortfolioHolding({
    required this.id,
    required this.name,
    required this.symbol,
    required this.amount,
    required this.priceUsd,
    required this.changePercent24h,
    required this.icon,
    required this.iconColor,
  });

  double get valueUsd => amount * priceUsd;

  double get changeUsd => valueUsd * (changePercent24h / 100);

  @override
  List<Object?> get props => [
        id,
        name,
        symbol,
        amount,
        priceUsd,
        changePercent24h,
        icon,
        iconColor,
      ];
}
