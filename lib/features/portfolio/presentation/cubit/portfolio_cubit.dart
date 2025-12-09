import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:team_18_final_project/features/portfolio/presentation/cubit/portfolio_state.dart';
import 'package:team_18_final_project/features/portfolio/presentation/portfolio_utils/app_portfolio_colors.dart';
import 'package:team_18_final_project/features/portfolio/presentation/portfolio_utils/app_portfolio_constants.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_holding.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:team_18_final_project/features/portfolio/domain/usecases/get_portfolio_overview_usecase.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/allocation_chart.dart';

class PortfolioCubit extends Cubit<PortfolioState> {
  final GetPortfolioOverviewUseCase getPortfolioOverview;
  final NumberFormat _currencyFormat = NumberFormat.simpleCurrency(
    decimalDigits: AppPortfolioConstants.decimalDigitsForCurrency,
  );

  PortfolioCubit({
    required this.getPortfolioOverview,
  }) : super(PortfolioState.loading());

  Future<void> load() async {
    emit(PortfolioState.loading());
    final result = await getPortfolioOverview();
    result.fold(
      (failure) => emit(PortfolioState.error(failure.message)),
      (overview) => emit(_mapToState(overview)),
    );
  }

  Future<void> loadForMonth(int monthIndex) async {
    emit(PortfolioState.loading());
    final days = AppPortfolioConstants.monthIndexToDays[monthIndex] ??
        AppPortfolioConstants.defaultDays;
    final result = await getPortfolioOverview(days: days);
    result.fold(
      (failure) => emit(PortfolioState.error(failure.message)),
      (overview) => emit(_mapToState(overview)),
    );
  }

  PortfolioState _mapToState(PortfolioOverview overview) {
    final holdings = overview.holdings;
    final totalValue = overview.totalValue;
    final totalChange = overview.totalChangeUsd;
    final changePercent = totalValue == AppPortfolioConstants.zeroValue
        ? AppPortfolioConstants.zeroValue.toDouble()
        : (totalChange / totalValue) *
            AppPortfolioConstants.percentageMultiplier;

    final allocations = holdings
        .map((h) => AllocationSegment(
              value: h.valueUsd,
              color: AppPortfolioColors.getCryptoColor(h.id),
              label: _formatAllocationLabel(h),
            ))
        .toList();

    final holdingViews = holdings
        .map(
          (h) => HoldingViewData(
            name: h.name,
            symbol: h.symbol,
            percentage: _calculatePercentage(h, holdings),
            amount: '${h.amount} ${h.symbol}',
            value: _currencyFormat.format(h.valueUsd),
            change: _currencyFormat.format(h.changeUsd),
            changePercent:
                '${h.changePercent24h >= AppPortfolioConstants.zeroValue ? AppPortfolioConstants.positivePrefix : ''}${h.changePercent24h.toStringAsFixed(AppPortfolioConstants.decimalDigitsForPercent)}${AppPortfolioConstants.percentSuffix}',
            icon: AppPortfolioColors.getCryptoIcon(h.id),
            iconColor: AppPortfolioColors.getCryptoColor(h.id),
          ),
        )
        .toList();

    final changeLabel =
        '${changePercent >= AppPortfolioConstants.zeroValue ? AppPortfolioConstants.positivePrefix : ''}${changePercent.toStringAsFixed(AppPortfolioConstants.decimalDigitsForChangePercent)}${AppPortfolioConstants.percentSuffix} (${_currencyFormat.format(totalChange)}) ${AppPortfolioConstants.changeLabelSuffix}';

    return PortfolioState.loaded(
      totalValue: _currencyFormat.format(totalValue),
      changeLabel: changeLabel,
      allocations: allocations,
      holdings: holdingViews,
    );
  }

  double _calculatePercentage(
    PortfolioHolding holding,
    List<PortfolioHolding> holdings,
  ) {
    final total = holdings.fold<double>(
      AppPortfolioConstants.zeroValue.toDouble(),
      (sum, h) => sum + h.valueUsd,
    );
    if (total == AppPortfolioConstants.zeroValue) {
      return AppPortfolioConstants.zeroValue.toDouble();
    }
    return (holding.valueUsd / total) *
        AppPortfolioConstants.percentageMultiplier;
  }

  String _formatAllocationLabel(PortfolioHolding holding) {
    final valueLabel = _currencyFormat.format(holding.valueUsd);
    return '$valueLabel ${holding.symbol}';
  }
}
