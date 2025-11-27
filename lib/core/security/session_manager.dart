import 'dart:async';
import 'package:team_18_final_project/core/security/secure_storage_service.dart';

/// Manages user sessions with automatic timeout and logout
class SessionManager {
  static Timer? _sessionTimer;
  static DateTime? _lastActivity;
  static bool _isSessionActive = false;
  static VoidCallback? _onSessionExpired;

  /// Default session timeout: 30 minutes
  static const int defaultSessionTimeoutMinutes = 30;

  /// Initialize session manager
  static Future<void> initialize({VoidCallback? onSessionExpired}) async {
    _onSessionExpired = onSessionExpired;
    await _restoreSessionState();
    await checkSessionValidity();
  }

  /// Start a new session
  static Future<void> startSession() async {
    _isSessionActive = true;
    await updateActivity();
    await _startSessionTimer();
  }

  /// Update last activity timestamp
  static Future<void> updateActivity() async {
    _lastActivity = DateTime.now();
    await SecureStorageService.saveLastActivity();
  }

  /// Check if session is still valid
  static Future<bool> isSessionValid() async {
    if (!_isSessionActive) return false;

    final lastActivity = await SecureStorageService.getLastActivity();
    if (lastActivity == null) return false;

    final timeoutMinutes = await SecureStorageService.getSessionTimeout();
    final timeout = Duration(minutes: timeoutMinutes);
    final now = DateTime.now();

    return now.difference(lastActivity) <= timeout;
  }

  /// Check session validity and handle expiration
  static Future<void> checkSessionValidity() async {
    final isValid = await isSessionValid();
    if (!isValid && _isSessionActive) {
      await endSession();
      _onSessionExpired?.call();
    }
  }

  /// End the current session
  static Future<void> endSession() async {
    _isSessionActive = false;
    _sessionTimer?.cancel();
    _sessionTimer = null;
    _lastActivity = null;
  }

  /// Logout and clear all session data
  static Future<void> logout() async {
    await endSession();
    await SecureStorageService.clearUserData();
  }

  /// Complete logout (clears everything including settings)
  static Future<void> completeLogout() async {
    await endSession();
    await SecureStorageService.completeLogout();
  }

  /// Get remaining session time
  static Future<Duration?> getRemainingSessionTime() async {
    if (!_isSessionActive) return null;

    final lastActivity = await SecureStorageService.getLastActivity();
    if (lastActivity == null) return null;

    final timeoutMinutes = await SecureStorageService.getSessionTimeout();
    final timeout = Duration(minutes: timeoutMinutes);
    final now = DateTime.now();
    final elapsed = now.difference(lastActivity);

    if (elapsed >= timeout) return Duration.zero;

    return timeout - elapsed;
  }

  /// Set custom session timeout
  static Future<void> setSessionTimeout(int minutes) async {
    await SecureStorageService.saveSessionTimeout(minutes);
    // Restart timer with new timeout
    if (_isSessionActive) {
      await _startSessionTimer();
    }
  }

  /// Get current session timeout setting
  static Future<int> getSessionTimeout() async {
    return await SecureStorageService.getSessionTimeout();
  }

  /// Private: Start session timeout timer
  static Future<void> _startSessionTimer() async {
    _sessionTimer?.cancel();

    // Check every minute
    _sessionTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await checkSessionValidity();
    });
  }

  /// Private: Load session state from storage
  static Future<void> _restoreSessionState() async {
    _lastActivity = await SecureStorageService.getLastActivity();

    // If we have a token, treat the session as active so we can validate it
    final token = await SecureStorageService.getAuthToken();
    _isSessionActive = token != null;

    // If a token exists but no activity was stored, treat that as expired/invalid
    if (_isSessionActive && _lastActivity == null) {
      _isSessionActive = false;
      return;
    }

    if (_isSessionActive) {
      await _startSessionTimer();
    }
  }

  /// Dispose session manager
  static void dispose() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await SecureStorageService.getAuthToken();
    return token != null && _isSessionActive;
  }

  /// Check if a stored session is still valid (used on cold start)
  static Future<bool> hasValidSession() async {
    final token = await SecureStorageService.getAuthToken();
    if (token == null) return false;

    final lastActivity = await SecureStorageService.getLastActivity();
    if (lastActivity == null) return false;

    final timeoutMinutes = await SecureStorageService.getSessionTimeout();
    final timeout = Duration(minutes: timeoutMinutes);
    final isValid = DateTime.now().difference(lastActivity) <= timeout;

    _isSessionActive = isValid;
    if (isValid && _sessionTimer == null) {
      await _startSessionTimer();
    }

    return isValid;
  }

  /// Get session status
  static bool get isActive => _isSessionActive;

  /// Get last activity time
  static DateTime? get lastActivity => _lastActivity;
}

/// Callback type for session expiration
typedef VoidCallback = void Function();
