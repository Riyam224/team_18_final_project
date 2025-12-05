import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/allocation_chart.dart';

class PortfolioState extends Equatable {
  final bool isLoading;
  final String? error;
  final String totalValue;
  final String changeLabel;
  final List<AllocationSegment> allocations;
  final List<HoldingViewData> holdings;

  const PortfolioState({
    required this.isLoading,
    this.error,
    required this.totalValue,
    required this.changeLabel,
    required this.allocations,
    required this.holdings,
  });

  factory PortfolioState.loading() => const PortfolioState(
        isLoading: true,
        totalValue: '',
        changeLabel: '',
        allocations: [],
        holdings: [],
      );

  factory PortfolioState.loaded({
    required String totalValue,
    required String changeLabel,
    required List<AllocationSegment> allocations,
    required List<HoldingViewData> holdings,
  }) =>
      PortfolioState(
        isLoading: false,
        totalValue: totalValue,
        changeLabel: changeLabel,
        allocations: allocations,
        holdings: holdings,
      );

  factory PortfolioState.error(String message) => PortfolioState(
        isLoading: false,
        error: message,
        totalValue: '',
        changeLabel: '',
        allocations: const [],
        holdings: const [],
      );

  @override
  List<Object?> get props => [
        isLoading,
        error,
        totalValue,
        changeLabel,
        allocations,
        holdings,
      ];
}

class HoldingViewData extends Equatable {
  final String name;
  final String symbol;
  final double percentage;
  final String amount;
  final String value;
  final String change;
  final String changePercent;
  final IconData icon;
  final Color iconColor;

  const HoldingViewData({
    required this.name,
    required this.symbol,
    required this.percentage,
    required this.amount,
    required this.value,
    required this.change,
    required this.changePercent,
    required this.icon,
    required this.iconColor,
  });

  @override
  List<Object?> get props => [
        name,
        symbol,
        percentage,
        amount,
        value,
        change,
        changePercent,
        icon,
        iconColor,
      ];
}
