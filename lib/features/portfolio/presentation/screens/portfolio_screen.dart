import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/features/home/presentation/widgets/section_title.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/allocation_chart.dart';
import 'package:team_18_final_project/features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/holding_card.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/month_selector.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/total_value_card.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/transaction_tile.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                      'Portfolio',
                      style: AppTextStyles.headlineLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textWhite : AppColors.primary,
                      ),
                    ),
                    AppSpacing.gapH27,
                    TotalValueCard(
                      title: 'Total Value',
                      value: state.totalValue,
                      changeLabel: state.changeLabel,
                    ),
                    AppSpacing.gapH27,
                    MonthSelector(
                      months: const ['Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'],
                      initialIndex: 1,
                    ),
                    AppSpacing.gapH27,
                    AllocationChart(
                      segments: state.allocations,
                      centerLabel: state.totalValue,
                    ),
                    AppSpacing.gapH33,
                    const SectionTitle(title: 'My Holdings'),
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
                    const SectionTitle(title: 'Recent Transactions'),
                    AppSpacing.gapH12,
                    ..._transactions.map(
                      (t) => TransactionTile(
                        title: t.title,
                        subtitle: t.subtitle,
                        amount: t.amount,
                        valueChange: t.valueChange,
                        isBuy: t.isBuy,
                      ),
                    ),
                    SizedBox(height: AppSizing.h24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TransactionModel {
  final String title;
  final String subtitle;
  final String amount;
  final String valueChange;
  final bool isBuy;

  _TransactionModel({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.valueChange,
    required this.isBuy,
  });
}

final _transactions = <_TransactionModel>[
  _TransactionModel(
    title: 'Buy Bitcoin',
    subtitle: '2 hours ago',
    amount: '0.01 BTC',
    valueChange: '+\$452.50',
    isBuy: true,
  ),
  _TransactionModel(
    title: 'Sell Ethereum',
    subtitle: '1 day ago',
    amount: '0.5 ETH',
    valueChange: '+\$1,050.25',
    isBuy: true,
  ),
];
