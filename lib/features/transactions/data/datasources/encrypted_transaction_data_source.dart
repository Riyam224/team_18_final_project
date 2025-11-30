import 'dart:convert';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/security/interfaces/i_encryption_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/features/transactions/domain/entities/transaction_record.dart';

/// Persists transaction history securely via encrypted storage
class EncryptedTransactionDataSource {
  final ISecureStorage _secureStorage;
  final IEncryptionService _encryptionService;

  EncryptedTransactionDataSource({
    required ISecureStorage secureStorage,
    required IEncryptionService encryptionService,
  })  : _secureStorage = secureStorage,
        _encryptionService = encryptionService;

  Future<List<TransactionRecord>> getTransactions() async {
    final result = await _secureStorage.read(
      key: StorageKeysConfig.transactionHistory,
    );
    final cipherText = result.fold((_) => null, (value) => value);
    if (cipherText == null) return <TransactionRecord>[];

    final decrypted = await _encryptionService.decrypt(cipherText);
    final payload = decrypted.getOrElse(() => cipherText);

    try {
      final List<dynamic> decoded = jsonDecode(payload);
      return decoded
          .map((e) => TransactionRecord.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return <TransactionRecord>[];
    }
  }

  Future<void> saveTransactions(List<TransactionRecord> records) async {
    final jsonString = jsonEncode(records.map((e) => e.toMap()).toList());
    final encrypted = await _encryptionService.encrypt(jsonString);
    final payload = encrypted.getOrElse(() => jsonString);
    await _secureStorage.write(
      key: StorageKeysConfig.transactionHistory,
      value: payload,
    );
  }

  Future<void> clear() async {
    await _secureStorage.delete(key: StorageKeysConfig.transactionHistory);
  }
}
