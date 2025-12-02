import 'package:team_18_final_project/features/transactions/domain/entities/transaction_record.dart';

abstract class TransactionRepository {
  Future<List<TransactionRecord>> getTransactions();
  Future<void> addTransaction(TransactionRecord record);
  Future<void> clearTransactions();
}
