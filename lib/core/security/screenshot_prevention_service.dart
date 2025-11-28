import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Service to prevent screenshots on sensitive screens
/// Works with SecureApplication package for background blur and screenshot blocking
class ScreenshotPreventionService {
  static const MethodChannel _channel = MethodChannel('screenshot_prevention');

  /// Enable screenshot prevention (Android only via FLAG_SECURE)
  static Future<void> enableScreenshotPrevention() async {
    try {
      await _channel.invokeMethod('enableSecureMode');
    } on PlatformException catch (e) {
      debugPrint('Failed to enable screenshot prevention: ${e.message}');
    }
  }

  /// Disable screenshot prevention
  static Future<void> disableScreenshotPrevention() async {
    try {
      await _channel.invokeMethod('disableSecureMode');
    } on PlatformException catch (e) {
      debugPrint('Failed to disable screenshot prevention: ${e.message}');
    }
  }

  /// List of routes that should have screenshot prevention
  /// These screens contain sensitive financial data
  static const List<String> sensitiveRoutes = [
    '/home',
    '/portfolio',
    '/transactions',
    '/coinDetails',
    '/payment',
    '/buy-sell',
    '/wallet',
    '/settings',
    '/profile',
  ];

  /// Check if a route is sensitive and requires screenshot prevention
  static bool isSensitiveRoute(String? routeName) {
    if (routeName == null) return false;
    return sensitiveRoutes.any((route) => routeName.startsWith(route));
  }
}
