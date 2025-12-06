// Imports Equatable for value equality comparison (compares values, not references)
import 'package:equatable/equatable.dart';

/// Domain entity representing user's cryptocurrency portfolio balance and performance
/// Extends Equatable to enable value-based equality comparison for state management
/// This is a pure business logic object with no knowledge of data sources or UI
class PortfolioBalance extends Equatable {
  /// Total portfolio value in USD (raw double value)
  final double totalBalance;

  /// Percentage change in portfolio value over the past week
  /// Positive = portfolio gained value, Negative = portfolio lost value
  final double weeklyChangePercentage;

  /// Constructor requiring balance and weekly change data
  const PortfolioBalance({
    required this.totalBalance,
    required this.weeklyChangePercentage,
  });

  /// Equatable props for value comparison
  /// Two PortfolioBalance objects are equal if both properties match
  @override
  List<Object?> get props => [totalBalance, weeklyChangePercentage];
}
