import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/features/market/domain/usecases/get_coin_chart_usecase.dart';
import 'package:team_18_final_project/features/market/domain/usecases/get_coin_details_usecase.dart';
import 'coin_details_state.dart';

class CoinDetailsCubit extends Cubit<CoinDetailsState> {
  final GetCoinDetailsUseCase _getCoinDetails;
  final GetCoinChartUseCase _getCoinChart;

  String _selectedPeriod = '1d';
  String? _coinId;

  CoinDetailsCubit(
    this._getCoinDetails,
    this._getCoinChart,
  ) : super(const CoinDetailsInitial());

  Future<void> loadCoinDetails(String coinId) async {
    if (coinId.isEmpty) {
      emit(const CoinDetailsError('Invalid coin id'));
      return;
    }

    _coinId = coinId;
    _selectedPeriod = '1d';
    emit(const CoinDetailsLoading());

    final detailsResult = await _getCoinDetails(coinId);
    detailsResult.fold(
      (failure) => emit(CoinDetailsError(failure.message)),
      (coin) async {
        final chartResult = await _getCoinChart(
            coinId: coinId, days: _mapPeriodToDays(_selectedPeriod));
        chartResult.fold(
          (failure) => emit(CoinDetailsError(failure.message)),
          (chart) => emit(
            CoinDetailsLoaded(
              coin: coin.copyWith(chartPoints: chart),
              selectedPeriod: _selectedPeriod,
              chartPoints: chart,
            ),
          ),
        );
      },
    );
  }

  Future<void> updateChartPeriod(String period) async {
    if (state is! CoinDetailsLoaded || _coinId == null) return;
    final current = state as CoinDetailsLoaded;
    emit(current.copyWith(chartLoading: true, selectedPeriod: period));
    _selectedPeriod = period;

    final chartResult =
        await _getCoinChart(coinId: _coinId!, days: _mapPeriodToDays(period));
    chartResult.fold(
      (failure) => emit(CoinDetailsError(failure.message)),
      (chart) => emit(
        current.copyWith(
          chartPoints: chart,
          selectedPeriod: period,
          chartLoading: false,
          coin: current.coin.copyWith(chartPoints: chart),
        ),
      ),
    );
  }

  String _mapPeriodToDays(String period) {
    return switch (period) {
      '1h' => '1',
      '1d' => '1',
      '1w' => '7',
      '1m' => '30',
      '1y' => '365',
      _ => '1',
    };
  }
}
