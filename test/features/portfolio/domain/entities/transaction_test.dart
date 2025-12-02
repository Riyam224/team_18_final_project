import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/transaction.dart';
import '../../../../helpers/test_utils.dart';

void main() {
  group('Transaction', () {
    late Transaction buyTransaction;
    late Transaction sellTransaction;

    setUp(() {
      buyTransaction = Transaction(
        id: '1',
        cryptoName: 'Bitcoin',
        cryptoSymbol: 'BTC',
        type: TransactionType.buy,
        amount: 0.5,
        valueUsd: 25000.0,
        timestamp: fixedNow,
      );

      sellTransaction = Transaction(
        id: '2',
        cryptoName: 'Ethereum',
        cryptoSymbol: 'ETH',
        type: TransactionType.sell,
        amount: 2.0,
        valueUsd: 6000.0,
        timestamp: fixedNow.subtract(const Duration(days: 1)),
      );
    });

    test('creates buy transaction', () {
      expect(buyTransaction.id, '1');
      expect(buyTransaction.cryptoName, 'Bitcoin');
      expect(buyTransaction.cryptoSymbol, 'BTC');
      expect(buyTransaction.type, TransactionType.buy);
      expectClose(buyTransaction.amount, 0.5);
      expectClose(buyTransaction.valueUsd, 25000.0);
      expect(buyTransaction.timestamp, fixedNow);
    });

    test('creates sell transaction', () {
      expect(sellTransaction.id, '2');
      expect(sellTransaction.type, TransactionType.sell);
      expectClose(sellTransaction.amount, 2.0);
      expectClose(sellTransaction.valueUsd, 6000.0);
      expect(sellTransaction.timestamp, fixedNow.subtract(const Duration(days: 1)));
    });

    test('equatable compares all fields', () {
      final duplicate = Transaction(
        id: buyTransaction.id,
        cryptoName: buyTransaction.cryptoName,
        cryptoSymbol: buyTransaction.cryptoSymbol,
        type: buyTransaction.type,
        amount: buyTransaction.amount,
        valueUsd: buyTransaction.valueUsd,
        timestamp: buyTransaction.timestamp,
      );

      expect(buyTransaction, duplicate);
      expect(buyTransaction.hashCode, duplicate.hashCode);
    });

    test('transactions differ when any field changes', () {
      final changed = buyTransaction.copyWith(amount: 1.0);

      expect(buyTransaction == changed, isFalse);
    });
  });
}

extension on Transaction {
  Transaction copyWith({
    String? id,
    String? cryptoName,
    String? cryptoSymbol,
    TransactionType? type,
    double? amount,
    double? valueUsd,
    DateTime? timestamp,
  }) {
    return Transaction(
      id: id ?? this.id,
      cryptoName: cryptoName ?? this.cryptoName,
      cryptoSymbol: cryptoSymbol ?? this.cryptoSymbol,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      valueUsd: valueUsd ?? this.valueUsd,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
