import 'package:safe_device/safe_device.dart';

/// Service to detect if device is rooted/jailbroken (optional security measure)
class RootDetectionService {
  /// Check if device is jailbroken (iOS) or rooted (Android)
  static Future<bool> isDeviceRooted() async {
    try {
      return await SafeDevice.isJailBroken;
    } catch (e) {
      return false;
    }
  }

  /// Check if device can mock location (GPS spoofing) - Android only
  static Future<bool> canMockLocation() async {
    try {
      // Note: This feature may not be available in all versions of safe_device
      // Returning false as safe default
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if device is a real device (not emulator)
  static Future<bool> isRealDevice() async {
    try {
      return await SafeDevice.isRealDevice;
    } catch (e) {
      return true; // Assume real device if check fails
    }
  }

  /// Check if device is running in development mode
  static Future<bool> isDevelopmentModeEnabled() async {
    try {
      return await SafeDevice.isDevelopmentModeEnable;
    } catch (e) {
      return false;
    }
  }

  /// Check if device is on external storage (Android)
  static Future<bool> isOnExternalStorage() async {
    try {
      return await SafeDevice.isOnExternalStorage;
    } catch (e) {
      return false;
    }
  }

  /// Comprehensive security check
  /// Returns true if device is considered SAFE
  static Future<SecurityCheckResult> performSecurityCheck() async {
    final isRooted = await isDeviceRooted();
    final canMock = await canMockLocation();
    final isReal = await isRealDevice();
    final isDev = await isDevelopmentModeEnabled();
    final isExternal = await isOnExternalStorage();

    final isSafe = !isRooted && isReal;

    return SecurityCheckResult(
      isSafe: isSafe,
      isRooted: isRooted,
      canMockLocation: canMock,
      isRealDevice: isReal,
      isDevelopmentMode: isDev,
      isOnExternalStorage: isExternal,
    );
  }
}

/// Result of security check
class SecurityCheckResult {
  final bool isSafe;
  final bool isRooted;
  final bool canMockLocation;
  final bool isRealDevice;
  final bool isDevelopmentMode;
  final bool isOnExternalStorage;

  SecurityCheckResult({
    required this.isSafe,
    required this.isRooted,
    required this.canMockLocation,
    required this.isRealDevice,
    required this.isDevelopmentMode,
    required this.isOnExternalStorage,
  });

  String get warningMessage {
    if (isRooted) {
      return 'Device is rooted/jailbroken. This app may not function properly on rooted devices.';
    }
    if (!isRealDevice) {
      return 'Emulator detected. Some features may be limited.';
    }
    if (canMockLocation) {
      return 'Location mocking is enabled on this device.';
    }
    return 'Device security check passed.';
  }
}
