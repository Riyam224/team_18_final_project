import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/features/market/domain/entities/chart_point.dart';
import 'package:team_18_final_project/features/market/domain/entities/coin_details.dart';

abstract class CoinDetailsState extends Equatable {
  const CoinDetailsState();

  @override
  List<Object?> get props => [];
}

class CoinDetailsInitial extends CoinDetailsState {
  const CoinDetailsInitial();
}

class CoinDetailsLoading extends CoinDetailsState {
  const CoinDetailsLoading();
}

class CoinDetailsLoaded extends CoinDetailsState {
  final CoinDetailsEntity coin;
  final List<ChartPoint> chartPoints;
  final String selectedPeriod;
  final bool chartLoading;

  const CoinDetailsLoaded({
    required this.coin,
    required this.chartPoints,
    required this.selectedPeriod,
    this.chartLoading = false,
  });

  CoinDetailsLoaded copyWith({
    CoinDetailsEntity? coin,
    List<ChartPoint>? chartPoints,
    String? selectedPeriod,
    bool? chartLoading,
  }) {
    return CoinDetailsLoaded(
      coin: coin ?? this.coin,
      chartPoints: chartPoints ?? this.chartPoints,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      chartLoading: chartLoading ?? this.chartLoading,
    );
  }

  @override
  List<Object?> get props => [coin, chartPoints, selectedPeriod, chartLoading];
}

class CoinDetailsError extends CoinDetailsState {
  final String message;

  const CoinDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
