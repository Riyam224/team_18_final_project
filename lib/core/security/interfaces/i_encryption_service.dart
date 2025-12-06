import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failures.dart';

/// Provides symmetric encryption/decryption for sensitive payloads.
abstract class IEncryptionService {
  /// Encrypts plain text and returns a base64Url-encoded blob (iv + cipher).
  Future<Either<Failure, String>> encrypt(String plaintext);

  /// Decrypts a base64Url-encoded blob and returns the original plain text.
  Future<Either<Failure, String>> decrypt(String cipherText);
}
