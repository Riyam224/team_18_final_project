import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/features/auth/domain/failures/storage_failure.dart';

/// Interface for secure storage operations
/// Provides abstraction over platform-specific secure storage implementations
abstract class ISecureStorage {
  /// Writes a value to secure storage
  Future<Either<StorageFailure, void>> write({
    required String key,
    required String value,
  });

  /// Reads a value from secure storage
  Future<Either<StorageFailure, String?>> read({required String key});

  /// Deletes a value from secure storage
  Future<Either<StorageFailure, void>> delete({required String key});

  /// Deletes all values from secure storage
  Future<Either<StorageFailure, void>> deleteAll();

  /// Checks if a key exists in secure storage
  Future<Either<StorageFailure, bool>> containsKey({required String key});

  /// Reads all keys from secure storage
  Future<Either<StorageFailure, Map<String, String>>> readAll();
}
