import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/features/auth/domain/failures/storage_failure.dart';

/// Implementation of ISecureStorage using flutter_secure_storage
class FlutterSecureStorageImpl implements ISecureStorage {
  final FlutterSecureStorage _storage;

  FlutterSecureStorageImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
              mOptions: MacOsOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  @override
  Future<Either<StorageFailure, void>> write({
    required String key,
    required String value,
  }) async {
    try {
      await _storage.write(key: key, value: value);
      return const Right(null);
    } on Exception catch (e) {
      // Handle macOS/iOS keychain duplicate item error (-25299)
      if (e.toString().contains('-25299') ||
          e.toString().contains('already exists')) {
        try {
          // Delete existing item and retry
          await _storage.delete(key: key);
          await _storage.write(key: key, value: value);
          return const Right(null);
        } catch (retryError) {
          return Left(
            StorageWriteFailure(
              details: 'Retry failed: $retryError',
            ),
          );
        }
      }
      return Left(
        StorageWriteFailure(
          details: e.toString(),
        ),
      );
    } catch (e) {
      return Left(
        StorageWriteFailure(
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<StorageFailure, String?>> read({required String key}) async {
    try {
      final value = await _storage.read(key: key);
      return Right(value);
    } catch (e) {
      return Left(
        StorageReadFailure(
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<StorageFailure, void>> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
      return const Right(null);
    } catch (e) {
      return Left(
        StorageDeleteFailure(
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<StorageFailure, void>> deleteAll() async {
    try {
      await _storage.deleteAll();
      return const Right(null);
    } catch (e) {
      return Left(
        StorageDeleteFailure(
          message: 'Failed to delete all from secure storage.',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<StorageFailure, bool>> containsKey(
      {required String key}) async {
    try {
      final contains = await _storage.containsKey(key: key);
      return Right(contains);
    } catch (e) {
      return Left(
        StorageReadFailure(
          message: 'Failed to check if key exists in secure storage.',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<StorageFailure, Map<String, String>>> readAll() async {
    try {
      final all = await _storage.readAll();
      return Right(all);
    } catch (e) {
      return Left(
        StorageReadFailure(
          message: 'Failed to read all from secure storage.',
          details: e.toString(),
        ),
      );
    }
  }
}
