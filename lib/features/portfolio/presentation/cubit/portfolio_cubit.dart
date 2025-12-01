import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
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

  PortfolioState _mapToState(PortfolioOverview overview) {
    final holdings = overview.holdings;
    final totalValue = overview.totalValue;
    final totalChange = overview.totalChangeUsd;
    // Weighted change % across holdings
    final changePercent =
        totalValue == 0 ? 0 : (totalChange / totalValue) * 100;

    final allocations = holdings
        .map((h) => AllocationSegment(
              value: h.valueUsd,
              color: h.iconColor,
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
                '${h.changePercent24h >= 0 ? '+' : ''}${h.changePercent24h.toStringAsFixed(2)}%',
            icon: h.icon,
            iconColor: h.iconColor,
          ),
        )
        .toList();

    final changeLabel =
        '${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(1)}% (${_currencyFormat.format(totalChange)}) Today';

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
