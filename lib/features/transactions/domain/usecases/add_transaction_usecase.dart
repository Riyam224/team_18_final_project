import 'package:team_18_final_project/features/transactions/domain/entities/transaction_record.dart';
import 'package:team_18_final_project/features/transactions/domain/repositories/transaction_repository.dart';

class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  Future<void> call(TransactionRecord record) {
    return repository.addTransaction(record);
  }
}
