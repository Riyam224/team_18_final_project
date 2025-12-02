import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/features/transactions/domain/entities/transaction_record.dart';
import 'package:team_18_final_project/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:team_18_final_project/features/transactions/domain/usecases/get_transactions_usecase.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late GetTransactionsUseCase useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = GetTransactionsUseCase(mockRepository);
  });

  group('GetTransactionsUseCase', () {
    final testTransactions = [
      TransactionRecord(
        id: 'tx_1',
        type: 'buy',
        amount: 100.0,
        asset: 'BTC',
        timestamp: DateTime(2024, 1, 1),
      ),
      TransactionRecord(
        id: 'tx_2',
        type: 'sell',
        amount: 50.0,
        asset: 'ETH',
        timestamp: DateTime(2024, 1, 2),
      ),
      TransactionRecord(
        id: 'tx_3',
        type: 'transfer',
        amount: 200.0,
        asset: 'USDT',
        timestamp: DateTime(2024, 1, 3),
      ),
    ];

    test('should get all transactions from repository', () async {
      // Arrange
      when(() => mockRepository.getTransactions())
          .thenAnswer((_) async => testTransactions);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(testTransactions));
      expect(result.length, 3);
      verify(() => mockRepository.getTransactions()).called(1);
    });

    test('should return empty list when no transactions exist', () async {
      // Arrange
      when(() => mockRepository.getTransactions())
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getTransactions()).called(1);
    });

    test('should return transactions in correct order', () async {
      // Arrange
      when(() => mockRepository.getTransactions())
          .thenAnswer((_) async => testTransactions);

      // Act
      final result = await useCase();

      // Assert
      expect(result[0].id, 'tx_1');
      expect(result[1].id, 'tx_2');
      expect(result[2].id, 'tx_3');
    });

    test('should propagate errors from repository', () async {
      // Arrange
      when(() => mockRepository.getTransactions())
          .thenThrow(Exception('Repository error'));

      // Act & Assert
      expect(
        () => useCase(),
        throwsException,
      );
    });

    test('should handle single transaction', () async {
      // Arrange
      final singleTransaction = [testTransactions.first];
      when(() => mockRepository.getTransactions())
          .thenAnswer((_) async => singleTransaction);

      // Act
      final result = await useCase();

      // Assert
      expect(result.length, 1);
      expect(result.first.id, 'tx_1');
    });

    test('should preserve transaction details', () async {
      // Arrange
      when(() => mockRepository.getTransactions())
          .thenAnswer((_) async => testTransactions);

      // Act
      final result = await useCase();

      // Assert
      final firstTransaction = result[0];
      expect(firstTransaction.id, 'tx_1');
      expect(firstTransaction.type, 'buy');
      expect(firstTransaction.amount, 100.0);
      expect(firstTransaction.asset, 'BTC');
      expect(firstTransaction.timestamp, DateTime(2024, 1, 1));
    });
  });
}
