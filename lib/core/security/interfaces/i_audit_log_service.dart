import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failures.dart';

/// Audit log entry
class AuditLogEntry {
  final String event;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  const AuditLogEntry({
    required this.event,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'event': event,
        'timestamp': timestamp.toIso8601String(),
        'metadata': metadata,
      };

  factory AuditLogEntry.fromJson(Map<String, dynamic> json) {
    return AuditLogEntry(
      event: json['event'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

/// Interface for audit logging operations
abstract class IAuditLogService {
  /// Logs an event
  Future<Either<Failure, void>> log({
    required String event,
    Map<String, dynamic>? metadata,
  });

  /// Gets all audit log entries
  Future<Either<Failure, List<AuditLogEntry>>> getAll();

  /// Gets recent audit log entries
  Future<Either<Failure, List<AuditLogEntry>>> getRecent({int limit = 50});

  /// Clears all audit log entries
  Future<Either<Failure, void>> clear();

  /// Clears old audit log entries (keeps only recent ones)
  Future<Either<Failure, void>> cleanup({required int keepCount});
}
