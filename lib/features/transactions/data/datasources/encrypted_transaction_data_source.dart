import 'dart:convert';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/features/transactions/domain/entities/transaction_record.dart';

/// Persists transaction history securely via encrypted storage.
class EncryptedTransactionDataSource {
  final ISecureStorage _secureStorage;

  EncryptedTransactionDataSource({
    required ISecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  Future<List<TransactionRecord>> getTransactions() async {
    final result = await _secureStorage.read(key: 'transaction_history');
    return result.fold(
      (_) => <TransactionRecord>[],
      (jsonString) {
        if (jsonString == null) return <TransactionRecord>[];
        try {
          final List<dynamic> decoded = jsonDecode(jsonString);
          return decoded
              .map((e) => TransactionRecord.fromMap(e as Map<String, dynamic>))
              .toList();
        } catch (e) {
          return <TransactionRecord>[];
        }
      },
    );
  }

  Future<void> saveTransactions(List<TransactionRecord> records) async {
    final jsonString = jsonEncode(records.map((e) => e.toMap()).toList());
    await _secureStorage.write(
      key: 'transaction_history',
      value: jsonString,
    );
  }

  Future<void> clear() async {
    await _secureStorage.delete(key: 'transaction_history');
  }
}
