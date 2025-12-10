import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/portfolio/data/datasources/transaction_local_data_source.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/transaction.dart';
import '../../../../helpers/test_utils.dart';

void main() {
  group('TransactionLocalDataSource', () {
    late TransactionLocalDataSource dataSource;

    setUp(() {
      dataSource = TransactionLocalDataSource(now: () => fixedNow);
    });

    test('returns seeded transactions in deterministic order', () {
      final transactions = dataSource.getRecentTransactions();

      expect(transactions, hasLength(2));
      expect(transactions.first.cryptoSymbol, 'BTC');
      expect(transactions.last.cryptoSymbol, 'ETH');
    });

    test('builds correct buy transaction snapshot', () {
      final tx = dataSource.getRecentTransactions().first;

      expect(tx.id, '1');
      expect(tx.type, TransactionType.buy);
      expect(tx.amount, 0.01);
      expectClose(tx.valueUsd, 452.50, delta: 1e-6);
      expect(tx.timestamp, fixedNow.subtract(const Duration(hours: 2)));
    });

    test('builds correct sell transaction snapshot', () {
      final tx = dataSource.getRecentTransactions().last;

      expect(tx.id, '2');
      expect(tx.type, TransactionType.sell);
      expect(tx.amount, 0.5);
      expectClose(tx.valueUsd, 1050.25, delta: 1e-6);
      expect(tx.timestamp, fixedNow.subtract(const Duration(days: 1)));
    });

    test('transactions remain immutable on repeated calls', () {
      final first = dataSource.getRecentTransactions();
      final second = dataSource.getRecentTransactions();

      expect(first, isNot(same(second)));
      expect(first.first.timestamp, second.first.timestamp);
      expect(first.last.timestamp, second.last.timestamp);
    });

    test('timestamps derive from provided clock only', () {
      final customNow = DateTime.utc(2030, 6, 1, 8, 30);
      final ds = TransactionLocalDataSource(now: () => customNow);

      final txs = ds.getRecentTransactions();

      expect(txs.first.timestamp, customNow.subtract(const Duration(hours: 2)));
      expect(txs.last.timestamp, customNow.subtract(const Duration(days: 1)));
    });
  });
}
