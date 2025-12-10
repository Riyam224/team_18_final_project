# Transactions Module

## Purpose
Securely persist transaction history (amount, currency, timestamp, note) locally using encrypted storage. No UI yet; consumed by portfolio/history views.

## Structure
```
features/transactions/
├─ data/datasources/encrypted_transaction_data_source.dart
├─ data/repositories/transaction_repository_impl.dart
├─ domain/entities/transaction_record.dart
├─ domain/repositories/transaction_repository.dart
└─ domain/usecases/add_transaction_usecase.dart,
   clear_transactions_usecase.dart,
   get_transactions_usecase.dart
```

## Dependencies
- `ISecureStorage` + `IEncryptionService` (injected by DI)
- `Uuid` for stable IDs

## Flow
```mermaid
flowchart TD
  A[AddTransactionUseCase(record)] --> B[TransactionRepositoryImpl]
  B --> C[EncryptedTransactionDataSource.getTransactions]
  C --> D[append + sort desc]
  D --> E[encrypt + write transaction_history]
```
- `getTransactions` decrypts stored JSON and maps back to `TransactionRecord`.
- `clearTransactions` deletes `transaction_history` key from secure storage.

## Models & Mapping
- `TransactionRecord.toMap()/fromMap()` for JSON serialization before encryption.
- Payload is encrypted per-device; corruption falls back to empty list to avoid crashes.
