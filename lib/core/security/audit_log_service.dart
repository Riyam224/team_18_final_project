import 'dart:convert';

import 'package:team_18_final_project/core/security/secure_storage_service.dart';

/// Lightweight audit logger that persists encrypted entries in secure storage.
class AuditLogService {
  static const _keyAuditLogs = 'audit_logs';
  static const int _maxEntries = 100;

  /// Append a log entry with type and message.
  static Future<void> log({
    required String type,
    required String message,
  }) async {
    final logs = await _readLogs();
    final entry = {
      'type': type,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    };
    logs.insert(0, entry); // newest first

    // Cap the list to avoid unbounded growth
    if (logs.length > _maxEntries) {
      logs.removeRange(_maxEntries, logs.length);
    }

    await SecureStorageService.write(_keyAuditLogs, jsonEncode(logs));
  }

  /// Retrieve all stored logs (newest first).
  static Future<List<Map<String, dynamic>>> getLogs() async {
    return await _readLogs();
  }

  /// Clear all audit logs.
  static Future<void> clear() async {
    await SecureStorageService.delete(_keyAuditLogs);
  }

  static Future<List<Map<String, dynamic>>> _readLogs() async {
    final raw = await SecureStorageService.read(_keyAuditLogs);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }
}
