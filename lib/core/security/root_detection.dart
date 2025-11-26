import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class RootDetection {
  static Future<bool> isUnsafe() async {
    if (Platform.isAndroid) {
      return await _isAndroidRooted();
    } else if (Platform.isIOS) {
      return await _isIOSJailbroken();
    }
    return false;
  }

  // ---------------------------
  // ANDROID ROOT DETECTION
  // ---------------------------
  static Future<bool> _isAndroidRooted() async {
    final paths = [
      '/system/app/Superuser.apk',
      '/system/bin/su',
      '/system/xbin/su',
      '/system/sd/xbin/su',
      '/system/bin/failsafe/su',
      '/su/bin/su'
    ];

    for (final path in paths) {
      final file = File(path);
      if (await file.exists()) return true;
    }

    return false;
  }

  // ---------------------------
  // iOS JAILBREAK DETECTION
  // ---------------------------
  static Future<bool> _isIOSJailbroken() async {
    final paths = [
      '/Applications/Cydia.app',
      '/Library/MobileSubstrate/MobileSubstrate.dylib',
      '/usr/sbin/sshd',
      '/etc/apt'
    ];

    for (final path in paths) {
      final file = File(path);
      if (await file.exists()) return true;
    }

    return false;
  }
}
