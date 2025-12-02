import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:team_18_final_project/features/portfolio/presentation/portfolio_utils/app_portfolio_colors.dart';
import 'package:team_18_final_project/features/portfolio/presentation/portfolio_utils/app_portfolio_constants.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_holding.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:team_18_final_project/features/portfolio/domain/usecases/get_portfolio_overview_usecase.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/allocation_chart.dart';

part 'portfolio_state.dart';

class PortfolioCubit extends Cubit<PortfolioState> {
  final GetPortfolioOverviewUseCase getPortfolioOverview;
  final NumberFormat _currencyFormat =
      NumberFormat.simpleCurrency(decimalDigits: 2);

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
    final days = AppPortfolioConstants.monthIndexToDays[monthIndex] ?? 30;
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
    final changePercent =
        totalValue == 0 ? 0 : (totalChange / totalValue) * 100;

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
                '${h.changePercent24h >= 0 ? AppPortfolioConstants.positivePrefix : ''}${h.changePercent24h.toStringAsFixed(2)}${AppPortfolioConstants.percentSuffix}',
            icon: AppPortfolioColors.getCryptoIcon(h.id),
            iconColor: AppPortfolioColors.getCryptoColor(h.id),
          ),
        )
        .toList();

    final changeLabel =
        '${changePercent >= 0 ? AppPortfolioConstants.positivePrefix : ''}${changePercent.toStringAsFixed(1)}${AppPortfolioConstants.percentSuffix} (${_currencyFormat.format(totalChange)}) ${AppPortfolioConstants.changeLabelSuffix}';

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
    final total = holdings.fold<double>(0, (sum, h) => sum + h.valueUsd);
    if (total == 0) return 0;
    return (holding.valueUsd / total) * 100;
  }

  String _formatAllocationLabel(PortfolioHolding holding) {
    final valueLabel = _currencyFormat.format(holding.valueUsd);
    return '$valueLabel ${holding.symbol}';
  }
}
