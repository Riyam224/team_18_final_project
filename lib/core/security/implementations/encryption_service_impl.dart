import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/error/failures.dart';
import 'package:team_18_final_project/core/security/interfaces/i_encryption_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';

/// AES-256 encryption service backed by a per-device key stored in secure storage.
class EncryptionServiceImpl implements IEncryptionService {
  final ISecureStorage _secureStorage;

  EncryptionServiceImpl({required ISecureStorage secureStorage})
      : _secureStorage = secureStorage;

  @override
  Future<Either<Failure, String>> encrypt(String plaintext) async {
    try {
      final key = await _getOrCreateKey();
      final iv = enc.IV.fromSecureRandom(16);
      final encrypter = enc.Encrypter(
        enc.AES(key, mode: enc.AESMode.cbc, padding: 'PKCS7'),
      );
      final encrypted = encrypter.encrypt(plaintext, iv: iv);
      final blob = base64UrlEncode(iv.bytes + encrypted.bytes);
      return Right(blob);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to encrypt payload',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> decrypt(String cipherText) async {
    try {
      final key = await _getOrCreateKey();
      final raw = base64Url.decode(cipherText);
      final iv = enc.IV(raw.sublist(0, 16));
      final cipher = enc.Encrypted(raw.sublist(16));
      final encrypter = enc.Encrypter(
        enc.AES(key, mode: enc.AESMode.cbc, padding: 'PKCS7'),
      );
      final decrypted = encrypter.decrypt(cipher, iv: iv);
      return Right(decrypted);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to decrypt payload',
          details: e.toString(),
        ),
      );
    }
  }

  Future<enc.Key> _getOrCreateKey() async {
    final existing = await _secureStorage.read(
      key: StorageKeysConfig.encryptionKey,
    );

    final stored = existing.fold((_) => null, (v) => v);
    if (stored != null && stored.isNotEmpty) {
      final bytes = base64Url.decode(stored);
      return enc.Key(Uint8List.fromList(bytes));
    }

    final random = Random.secure();
    final keyBytes = List<int>.generate(32, (_) => random.nextInt(256));
    final encoded = base64UrlEncode(keyBytes);
    await _secureStorage.write(
      key: StorageKeysConfig.encryptionKey,
      value: encoded,
    );
    return enc.Key(Uint8List.fromList(keyBytes));
  }
}
