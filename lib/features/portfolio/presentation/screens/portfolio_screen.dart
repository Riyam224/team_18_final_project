import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/constants/app_sizing.dart';
import 'package:team_18_final_project/core/constants/app_spacing.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/home/presentation/widgets/section_title.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/allocation_chart.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/holding_card.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/month_selector.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/total_value_card.dart';
import 'package:team_18_final_project/features/portfolio/presentation/widgets/transaction_tile.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final holdings = _mockHoldings;
    final transactions = _mockTransactions;
    final allocationSegments = _mockAllocations
        .map((e) => AllocationSegment(
              value: e['value'] as double,
              color: e['color'] as Color,
              label: e['label'] as String,
            ))
        .toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.darkBackground2 : AppColors.lightBackground;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
              const TotalValueCard(
                title: 'Total Value',
                value: '\$143,421.20',
                changeLabel: '+2.5% (\$305.20) Today',
              ),
              AppSpacing.gapH27,
              MonthSelector(
                months: const ['Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'],
                initialIndex: 1,
              ),
              AppSpacing.gapH27,
              AllocationChart(
                segments: allocationSegments,
                centerLabel: '\$143,421.20',
              ),
              AppSpacing.gapH33,
              const SectionTitle(title: 'My Holdings'),
              AppSpacing.gapH12,
              ...holdings.map((h) => HoldingCard(
                    name: h.name,
                    symbol: h.symbol,
                    percentage: h.percentage,
                    amount: h.amount,
                    value: h.value,
                    change: h.change,
                    changePercent: h.changePercent,
                    icon: h.icon,
                    iconColor: h.iconColor,
                  )),
              AppSpacing.gapH20,
              SectionTitle(
                title: 'Recent Transactions',
                actionText: null,
                onActionTap: null,
              ),
              AppSpacing.gapH12,
              ...transactions.map(
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
        ),
      ),
    );
  }
}

class _HoldingModel {
  final String name;
  final String symbol;
  final double percentage;
  final String amount;
  final String value;
  final String change;
  final String changePercent;
  final IconData icon;
  final Color iconColor;

  _HoldingModel({
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

final _mockAllocations = [
  {
    'label': '\$54,382.64 BTC',
    'value': 54382.64,
    'color': AppColors.accentPurple
  },
  {'label': '\$4,145.61 ETH', 'value': 4145.61, 'color': AppColors.accentBlue},
  {'label': '\$64,20.5 LTC', 'value': 6420.5, 'color': AppColors.secondary},
];

final _mockHoldings = <_HoldingModel>[
  _HoldingModel(
    name: 'Bitcoin',
    symbol: 'BTC',
    percentage: 50,
    amount: '0.05 BTC',
    value: '\$2,262.53',
    change: '+\$145.20',
    changePercent: '+6.85%',
    icon: Icons.currency_bitcoin,
    iconColor: AppColors.secondary,
  ),
  _HoldingModel(
    name: 'Ethereum',
    symbol: 'ETH',
    percentage: 30,
    amount: '1.5 ETH',
    value: '\$3,150.75',
    change: '+\$56.70',
    changePercent: '+1.83%',
    icon: Icons.token,
    iconColor: AppColors.primary,
  ),
  _HoldingModel(
    name: 'Litecoin',
    symbol: 'LTC',
    percentage: 20,
    amount: '26.3 LTC',
    value: '\$2,503.76',
    change: '+\$120.80',
    changePercent: '+5.07%',
    icon: Icons.monetization_on,
    iconColor: AppColors.accentBlue,
  ),
];

final _mockTransactions = <_TransactionModel>[
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
