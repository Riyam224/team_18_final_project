import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/features/transactions/domain/entities/transaction_record.dart';
import 'package:team_18_final_project/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:team_18_final_project/features/transactions/domain/usecases/add_transaction_usecase.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late AddTransactionUseCase useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = AddTransactionUseCase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(TransactionRecord(
      id: 'test_id',
      type: 'buy',
      amount: 100.0,
      asset: 'BTC',
      timestamp: DateTime.now(),
    ));
  });

  group('AddTransactionUseCase', () {
    final testTransaction = TransactionRecord(
      id: 'tx_123',
      type: 'buy',
      amount: 0.5,
      asset: 'BTC',
      timestamp: DateTime(2024, 1, 1),
      note: 'Test purchase',
    );

    test('should add transaction to repository', () async {
      // Arrange
      when(() => mockRepository.addTransaction(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      await useCase(testTransaction);

      // Assert
      verify(() => mockRepository.addTransaction(testTransaction)).called(1);
    });

    test('should handle transaction with null note', () async {
      // Arrange
      final transactionWithoutNote = TransactionRecord(
        id: 'tx_456',
        type: 'sell',
        amount: 1000.0,
        asset: 'ETH',
        timestamp: DateTime(2024, 1, 2),
      );

      when(() => mockRepository.addTransaction(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      await useCase(transactionWithoutNote);

      // Assert
      verify(() => mockRepository.addTransaction(transactionWithoutNote))
          .called(1);
    });

    test('should propagate errors from repository', () async {
      // Arrange
      when(() => mockRepository.addTransaction(any()))
          .thenThrow(Exception('Repository error'));

      // Act & Assert
      expect(
        () => useCase(testTransaction),
        throwsException,
      );
    });

    test('should handle multiple transaction types', () async {
      // Arrange
      final buyTransaction = TransactionRecord(
        id: 'tx_buy',
        type: 'buy',
        amount: 500.0,
        asset: 'BTC',
        timestamp: DateTime.now(),
      );

      final sellTransaction = TransactionRecord(
        id: 'tx_sell',
        type: 'sell',
        amount: 200.0,
        asset: 'ETH',
        timestamp: DateTime.now(),
      );

      final transferTransaction = TransactionRecord(
        id: 'tx_transfer',
        type: 'transfer',
        amount: 50.0,
        asset: 'USDT',
        timestamp: DateTime.now(),
      );

      when(() => mockRepository.addTransaction(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      await useCase(buyTransaction);
      await useCase(sellTransaction);
      await useCase(transferTransaction);

      // Assert
      verify(() => mockRepository.addTransaction(buyTransaction)).called(1);
      verify(() => mockRepository.addTransaction(sellTransaction)).called(1);
      verify(() => mockRepository.addTransaction(transferTransaction))
          .called(1);
    });

    test('should handle large transaction amounts', () async {
      // Arrange
      final largeTransaction = TransactionRecord(
        id: 'tx_large',
        type: 'buy',
        amount: 999999.99,
        asset: 'BTC',
        timestamp: DateTime.now(),
      );

      when(() => mockRepository.addTransaction(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      await useCase(largeTransaction);

      // Assert
      verify(() => mockRepository.addTransaction(largeTransaction)).called(1);
    });
  });
}
