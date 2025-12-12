import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/extension/app_extension.dart';
import 'package:team_18_final_project/features/home/presentation/widgets/section_title.dart';
import 'package:team_18_final_project/features/portfolio/data/datasources/transaction_local_data_source.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/transaction.dart';
import 'package:team_18_final_project/features/portfolio/presentation/portfolio_utils/app_portfolio_constants.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/allocation_chart.dart';
import 'package:team_18_final_project/features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'package:team_18_final_project/features/portfolio/presentation/cubit/portfolio_state.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/holding_card.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/month_selector.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/total_value_card.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/transaction_tile.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark();
    final backgroundColor =
        isDark ? AppColors.darkBackground2 : AppColors.lightBackground;

    return BlocProvider(
      create: (_) => sl<PortfolioCubit>()..load(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: BlocBuilder<PortfolioCubit, PortfolioState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null) {
                return Center(
                  child: Text(
                    state.error!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? AppColors.textWhite : AppColors.primary,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: AppSpacing.paddingH20V16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.portfolioTitle,
                      style: AppTextStyles.headlineLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textWhite : AppColors.primary,
                      ),
                    ),
                    AppSpacing.gapH27,
                    TotalValueCard(
                      title: context.tr.totalValue,
                      value: state.totalValue,
                      changeLabel: state.changeLabel,
                    ),
                    AppSpacing.gapH27,
                    MonthSelector(
                      months: AppStrings.monthsShort,
                      initialIndex: AppPortfolioConstants.defaultMonthIndex,
                      onChanged: (index) {
                        context.read<PortfolioCubit>().loadForMonth(index);
                      },
                    ),
                    AppSpacing.gapH27,
                    AllocationChart(
                      segments: state.allocations,
                      centerLabel: state.totalValue,
                    ),
                    AppSpacing.gapH33,
                    SectionTitle(title: context.tr.myHoldings),
                    AppSpacing.gapH12,
                    ...state.holdings.map(
                      (h) => HoldingCard(
                        name: h.name,
                        symbol: h.symbol,
                        percentage: h.percentage,
                        amount: h.amount,
                        value: h.value,
                        change: h.change,
                        changePercent: h.changePercent,
                        icon: h.icon,
                        iconColor: h.iconColor,
                      ),
                    ),
                    AppSpacing.gapH20,
                    SectionTitle(title: context.tr.recentTransactions),
                    AppSpacing.gapH12,
                    ...() {
                      final dataSource = TransactionLocalDataSource();
                      final transactions = dataSource.getRecentTransactions();
                      final currencyFormat = NumberFormat.simpleCurrency(
                        decimalDigits: AppPortfolioConstants.decimalDigitsForCurrency,
                      );

                      return transactions.map((t) {
                        final transactionType = t.type == TransactionType.buy
                            ? context.tr.buyTransaction
                            : context.tr.sellTransaction;
                        final title = '$transactionType ${t.cryptoName}';
                        final subtitle = _formatTimestamp(context, t.timestamp);
                        final amount = '${t.amount} ${t.cryptoSymbol}';
                        final valueChange =
                            '${t.type == TransactionType.buy ? '+' : '-'}${currencyFormat.format(t.valueUsd)}';
                        final isBuy = t.type == TransactionType.buy;

                        return TransactionTile(
                          title: title,
                          subtitle: subtitle,
                          amount: amount,
                          valueChange: valueChange,
                          isBuy: isBuy,
                        );
                      }).toList();
                    }(),
                    AppSpacing.gapH24,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(BuildContext context, DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours < AppPortfolioConstants.hoursInDay) {
      final hourLabel = difference.inHours == AppPortfolioConstants.oneValue
          ? context.tr.hour
          : context.tr.hours;
      return '${difference.inHours} $hourLabel ${context.tr.ago}';
    } else if (difference.inDays < AppPortfolioConstants.daysInWeek) {
      final dayLabel = difference.inDays == AppPortfolioConstants.oneValue
          ? context.tr.day
          : context.tr.days;
      return '${difference.inDays} $dayLabel ${context.tr.ago}';
    } else {
      return DateFormat(AppPortfolioConstants.dateFormat).format(timestamp);
    }
  }
}
