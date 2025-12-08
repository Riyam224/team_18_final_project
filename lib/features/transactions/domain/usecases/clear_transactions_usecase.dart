import 'package:team_18_final_project/features/transactions/domain/repositories/transaction_repository.dart';

class ClearTransactionsUseCase {
  final TransactionRepository repository;

  ClearTransactionsUseCase(this.repository);

  Future<void> call() {
    return repository.clearTransactions();
  }
}
