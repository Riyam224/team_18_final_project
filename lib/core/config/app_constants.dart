import 'package:flutter/services.dart';

class AppConstants {
  const AppConstants._();

  static const String appTitle = 'Team 18 Fintech';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  static const Size designSize = Size(375, 812);

  static const List<DeviceOrientation> allowedOrientations = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];

  static const double defaultDemoBalance = 143421.20;
  static const double defaultWeeklyChangePercent = 10.14;
  static const double weeklyChangeMultiplier = 7.0;

  static const List<int> autoLockTimeoutOptions = [
    0,
    30,
    60,
    300,
    600,
    1800,
  ];

  static const int defaultAutoLockTimeout = 60;

  /// Cache duration for market data (3 minutes to reduce API rate limit issues)
  static const Duration marketDataCacheDuration = Duration(minutes: 3);

  static const bool enableDebugLogging = true;
  static const bool enableNetworkLogging = true;

  static const bool enableBiometricAuth = true;
  static const bool enableAppLock = true;
  static const bool enableRootDetection = true;
  static const bool enableScreenshotPrevention = true;
}
