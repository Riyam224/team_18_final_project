import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/config/audit_log_config.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/error/failures.dart';
import 'package:team_18_final_project/core/security/interfaces/i_audit_log_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';

/// Implementation of IAuditLogService
class AuditLogServiceImpl implements IAuditLogService {
  final ISecureStorage _secureStorage;

  AuditLogServiceImpl({
    required ISecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  @override
  Future<Either<Failure, void>> log({
    required String event,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final logs = await _readLogs();

      final entry = AuditLogEntry(
        event: event,
        timestamp: DateTime.now(),
        metadata: metadata,
      );

      logs.insert(0, entry); // Newest first

      // Cap the list to prevent unbounded growth
      if (logs.length > AuditLogConfig.maxEntries) {
        logs.removeRange(AuditLogConfig.maxEntries, logs.length);
      }

      final jsonString = jsonEncode(logs.map((e) => e.toJson()).toList());

      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.auditLogs,
        value: jsonString,
      );

      return writeResult.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to log audit event',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<AuditLogEntry>>> getAll() async {
    try {
      final logs = await _readLogs();
      return Right(logs);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to retrieve audit logs',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<AuditLogEntry>>> getRecent({int limit = 50}) async {
    try {
      final logs = await _readLogs();
      final recentLogs = logs.take(limit).toList();
      return Right(recentLogs);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to retrieve recent audit logs',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clear() async {
    try {
      final deleteResult = await _secureStorage.delete(
        key: StorageKeysConfig.auditLogs,
      );

      return deleteResult.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to clear audit logs',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> cleanup({required int keepCount}) async {
    try {
      final logs = await _readLogs();

      if (logs.length <= keepCount) {
        return const Right(null);
      }

      final logsToKeep = logs.take(keepCount).toList();
      final jsonString = jsonEncode(logsToKeep.map((e) => e.toJson()).toList());

      final writeResult = await _secureStorage.write(
        key: StorageKeysConfig.auditLogs,
        value: jsonString,
      );

      return writeResult.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to cleanup audit logs',
          details: e.toString(),
        ),
      );
    }
  }

  /// Internal method to read logs from storage
  Future<List<AuditLogEntry>> _readLogs() async {
    final result = await _secureStorage.read(
      key: StorageKeysConfig.auditLogs,
    );

    return result.fold(
      (failure) => [],
      (jsonString) {
        if (jsonString == null || jsonString.isEmpty) {
          return [];
        }

        try {
          final List<dynamic> decoded = jsonDecode(jsonString);
          return decoded
              .map((json) => AuditLogEntry.fromJson(json as Map<String, dynamic>))
              .toList();
        } catch (e) {
          return [];
        }
      },
    );
  }
}
