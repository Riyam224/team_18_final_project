import 'package:equatable/equatable.dart';

class PortfolioBalance extends Equatable {
  final double totalBalance;
  final double weeklyChangePercentage;

  const PortfolioBalance({
    required this.totalBalance,
    required this.weeklyChangePercentage,
  });

  @override
  List<Object?> get props => [totalBalance, weeklyChangePercentage];
}
