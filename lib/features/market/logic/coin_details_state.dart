import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/features/market/data/models/coin_details_model.dart';

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

class CoinDetailsSuccess extends CoinDetailsState {
  final CoinDetailsModel coin;
  final String selectedChartPeriod;

  const CoinDetailsSuccess({
    required this.coin,
    required this.selectedChartPeriod,
  });

  @override
  List<Object?> get props => [coin, selectedChartPeriod];
}

class CoinDetailsError extends CoinDetailsState {
  final String message;

  const CoinDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}