import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/features/market/data/models/coin_chart_model.dart';
import 'package:team_18_final_project/features/market/data/repositories/market_repository.dart';
import 'package:team_18_final_project/features/market/data/models/coin_details_model.dart';
import 'coin_details_state.dart';

class CoinDetailsCubit extends Cubit<CoinDetailsState> {
  final MarketRepository _repository; 
  String _currentCoinId = '';

  CoinDetailsCubit(this._repository) : super(const CoinDetailsInitial());

  Future<void> fetchCoinDetails(String coinId) async {
    if (coinId.isEmpty) return;
    _currentCoinId = coinId;
    
    emit(const CoinDetailsLoading());
    try {
      final detailsFuture = _repository.fetchCoinDetails(coinId);
      final chartFuture = _repository.fetchMarketChart(coinId, '1'); 
      
      final results = await Future.wait([detailsFuture, chartFuture]);
    final coinDetails = results[0] as CoinDetailsModel;
    final chartData = results[1] as CoinChartModel;

      coinDetails.updateChartData = chartData; 

      emit(CoinDetailsSuccess(
        coin: coinDetails,
        selectedChartPeriod: '1d',
    ));
    } catch (e) {
      emit(CoinDetailsError(e.toString()));
    }
  }

  Future<void> updateChartPeriod(String period) async {
    if (state is! CoinDetailsSuccess) return; 
    final currentState = state as CoinDetailsSuccess; 
    
    
    try {
      
        final updatedCoin = currentState.coin;
        final newChartData = await _repository.fetchMarketChart(_currentCoinId, period);
        updatedCoin.updateChartData = newChartData;

      emit(CoinDetailsSuccess(
        coin: updatedCoin,
        selectedChartPeriod: period,
    ));
    } catch (e) {
      emit(CoinDetailsError('Failed to update chart: ${e.toString()}'));
    }
  }
}