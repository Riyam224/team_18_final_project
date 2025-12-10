import 'package:team_18_final_project/features/portfolio/domain/entities/transaction.dart';

class TransactionLocalDataSource {
  TransactionLocalDataSource({DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  List<Transaction> getRecentTransactions() {
    final now = _now();
    return [
      Transaction(
        id: '1',
        cryptoName: 'Bitcoin',
        cryptoSymbol: 'BTC',
        type: TransactionType.buy,
        amount: 0.01,
        valueUsd: 452.50,
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      Transaction(
        id: '2',
        cryptoName: 'Ethereum',
        cryptoSymbol: 'ETH',
        type: TransactionType.sell,
        amount: 0.5,
        valueUsd: 1050.25,
        timestamp: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
