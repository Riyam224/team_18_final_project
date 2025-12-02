import 'package:uuid/uuid.dart';

import 'package:team_18_final_project/features/transactions/data/datasources/encrypted_transaction_data_source.dart';
import 'package:team_18_final_project/features/transactions/domain/entities/transaction_record.dart';
import 'package:team_18_final_project/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._dataSource);

  final EncryptedTransactionDataSource _dataSource;
  final Uuid _uuid = const Uuid();

  @override
  Future<List<TransactionRecord>> getTransactions() {
    return _dataSource.getTransactions();
  }

  @override
  Future<void> addTransaction(TransactionRecord record) async {
    final current = await _dataSource.getTransactions();
    final withId = record.id.isEmpty ? record.copyWith(id: _uuid.v4()) : record;
    final updated = [...current, withId]..sort(
        (a, b) => b.timestamp.compareTo(a.timestamp),
      );
    await _dataSource.saveTransactions(updated);
  }

  @override
  Future<void> clearTransactions() {
    return _dataSource.clear();
  }
}
