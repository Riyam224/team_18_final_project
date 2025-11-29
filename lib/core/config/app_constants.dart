import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Application-wide configuration constants
/// Contains app metadata, UI configuration, and default values
class AppConstants {
  const AppConstants._();

  // ========= App Metadata =========
  static const String appTitle = 'Team 18 Fintech';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // ========= UI Configuration =========

  /// Design size for ScreenUtil (based on design mockups)
  /// Standard iPhone X/XS dimensions: 375x812
  static const Size designSize = Size(375, 812);

  /// Allowed device orientations
  static const List<DeviceOrientation> allowedOrientations = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];

  // ========= Mock/Demo Data =========

  /// Default balance for demo/offline mode
  static const double defaultDemoBalance = 143421.20;

  /// Default weekly change percentage for demo/offline mode
  static const double defaultWeeklyChangePercent = 10.14;

  /// Multiplier for calculating simulated weekly changes
  static const double weeklyChangeMultiplier = 7.0;

  // ========= Auto-Lock Options =========

  /// Available auto-lock timeout options (in seconds)
  /// 0 = Never, 30 = 30 seconds, 60 = 1 minute, 300 = 5 minutes,
  /// 600 = 10 minutes, 1800 = 30 minutes
  static const List<int> autoLockTimeoutOptions = [
    0,    // Never
    30,   // 30 seconds
    60,   // 1 minute
    300,  // 5 minutes
    600,  // 10 minutes
    1800, // 30 minutes
  ];

  /// Default auto-lock timeout (in seconds)
  static const int defaultAutoLockTimeout = 60;

  // ========= Cache Configuration =========

  /// Cache duration for market data
  static const Duration marketDataCacheDuration = Duration(seconds: 30);

  // ========= Network Configuration =========

  /// Enable/disable debug logging
  static const bool enableDebugLogging = true;

  /// Enable/disable network logging
  static const bool enableNetworkLogging = true;

  // ========= Feature Flags =========

  /// Enable biometric authentication
  static const bool enableBiometricAuth = true;

  /// Enable app lock feature
  static const bool enableAppLock = true;

  /// Enable root/jailbreak detection
  static const bool enableRootDetection = true;

  /// Enable screenshot prevention on sensitive screens
  static const bool enableScreenshotPrevention = true;
}
