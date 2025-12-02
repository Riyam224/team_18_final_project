/// Central export file for all configuration classes
/// Import this file to access all app configuration in one place
///
/// Usage:
/// ```dart
/// import 'package:team_18_final_project/core/config/app_config.dart';
///
/// // Access any configuration
/// final timeout = TimingConfig.connectionTimeout;
/// final minLength = ValidationConfig.minPasswordLength;
/// final message = ValidationMessagesConfig.emailRequired;
/// ```

// Configuration exports
export 'app_constants.dart';
export 'audit_log_config.dart';
export 'biometric_config.dart';
export 'firebase_config.dart';
export 'network_config.dart';
export 'routes_config.dart';
export 'security_config.dart';
export 'storage_keys_config.dart';
export 'timing_config.dart';
export 'validation_config.dart';
export 'validation_messages_config.dart';
