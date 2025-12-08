import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/features/transactions/domain/entities/transaction_record.dart';

void main() {
  group('TransactionRecord', () {
    final testTimestamp = DateTime(2024, 1, 1, 12, 0);

    test('should create transaction with all fields', () {
      // Act
      final transaction = TransactionRecord(
        id: 'tx_123',
        type: 'buy',
        amount: 100.0,
        asset: 'BTC',
        timestamp: testTimestamp,
        note: 'Test transaction',
      );

      // Assert
      expect(transaction.id, 'tx_123');
      expect(transaction.type, 'buy');
      expect(transaction.amount, 100.0);
      expect(transaction.asset, 'BTC');
      expect(transaction.timestamp, testTimestamp);
      expect(transaction.note, 'Test transaction');
    });

    test('should create transaction without note', () {
      // Act
      final transaction = TransactionRecord(
        id: 'tx_456',
        type: 'sell',
        amount: 50.0,
        asset: 'ETH',
        timestamp: testTimestamp,
      );

      // Assert
      expect(transaction.note, isNull);
    });

    test('should copy transaction with updated fields', () {
      // Arrange
      final original = TransactionRecord(
        id: 'tx_original',
        type: 'buy',
        amount: 100.0,
        asset: 'BTC',
        timestamp: testTimestamp,
        note: 'Original',
      );

      // Act
      final copied = original.copyWith(
        amount: 200.0,
        note: 'Updated',
      );

      // Assert
      expect(copied.id, 'tx_original');
      expect(copied.type, 'buy');
      expect(copied.amount, 200.0);
      expect(copied.asset, 'BTC');
      expect(copied.timestamp, testTimestamp);
      expect(copied.note, 'Updated');
    });

    test('should convert to map correctly', () {
      // Arrange
      final transaction = TransactionRecord(
        id: 'tx_map',
        type: 'transfer',
        amount: 75.5,
        asset: 'USDT',
        timestamp: testTimestamp,
        note: 'Map test',
      );

      // Act
      final map = transaction.toMap();

      // Assert
      expect(map['id'], 'tx_map');
      expect(map['type'], 'transfer');
      expect(map['amount'], 75.5);
      expect(map['asset'], 'USDT');
      expect(map['timestamp'], testTimestamp.toIso8601String());
      expect(map['note'], 'Map test');
    });

    test('should create from map correctly', () {
      // Arrange
      final map = {
        'id': 'tx_from_map',
        'type': 'buy',
        'amount': 150.0,
        'asset': 'BTC',
        'timestamp': testTimestamp.toIso8601String(),
        'note': 'From map',
      };

      // Act
      final transaction = TransactionRecord.fromMap(map);

      // Assert
      expect(transaction.id, 'tx_from_map');
      expect(transaction.type, 'buy');
      expect(transaction.amount, 150.0);
      expect(transaction.asset, 'BTC');
      expect(transaction.timestamp, testTimestamp);
      expect(transaction.note, 'From map');
    });

    test('should handle missing fields in fromMap', () {
      // Arrange
      final map = <String, dynamic>{};

      // Act
      final transaction = TransactionRecord.fromMap(map);

      // Assert
      expect(transaction.id, '');
      expect(transaction.type, '');
      expect(transaction.amount, 0);
      expect(transaction.asset, '');
      expect(transaction.note, isNull);
    });

    test('should handle null note in toMap', () {
      // Arrange
      final transaction = TransactionRecord(
        id: 'tx_null_note',
        type: 'sell',
        amount: 25.0,
        asset: 'ETH',
        timestamp: testTimestamp,
      );

      // Act
      final map = transaction.toMap();

      // Assert
      expect(map['note'], isNull);
    });

    test('should handle different transaction types', () {
      // Arrange & Act
      final buyTransaction = TransactionRecord(
        id: 'tx_buy',
        type: 'buy',
        amount: 100.0,
        asset: 'BTC',
        timestamp: testTimestamp,
      );

      final sellTransaction = TransactionRecord(
        id: 'tx_sell',
        type: 'sell',
        amount: 50.0,
        asset: 'ETH',
        timestamp: testTimestamp,
      );

      final transferTransaction = TransactionRecord(
        id: 'tx_transfer',
        type: 'transfer',
        amount: 200.0,
        asset: 'USDT',
        timestamp: testTimestamp,
      );

      // Assert
      expect(buyTransaction.type, 'buy');
      expect(sellTransaction.type, 'sell');
      expect(transferTransaction.type, 'transfer');
    });

    test('should handle decimal amounts correctly', () {
      // Arrange & Act
      final transaction = TransactionRecord(
        id: 'tx_decimal',
        type: 'buy',
        amount: 123.456789,
        asset: 'BTC',
        timestamp: testTimestamp,
      );

      // Assert
      expect(transaction.amount, 123.456789);
    });

    test('should roundtrip through map conversion', () {
      // Arrange
      final original = TransactionRecord(
        id: 'tx_roundtrip',
        type: 'buy',
        amount: 999.99,
        asset: 'BTC',
        timestamp: testTimestamp,
        note: 'Roundtrip test',
      );

      // Act
      final map = original.toMap();
      final recovered = TransactionRecord.fromMap(map);

      // Assert
      expect(recovered.id, original.id);
      expect(recovered.type, original.type);
      expect(recovered.amount, original.amount);
      expect(recovered.asset, original.asset);
      expect(recovered.timestamp, original.timestamp);
      expect(recovered.note, original.note);
    });
  });
}
