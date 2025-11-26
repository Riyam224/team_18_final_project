import 'package:safe_device/safe_device.dart';

/// Legacy root detection - use RootDetectionService instead
/// This file is kept for backward compatibility
@Deprecated('Use RootDetectionService from root_detection_service.dart instead')
class RootDetection {
  static Future<bool> isUnsafe() async {
    try {
      return await SafeDevice.isJailBroken;
    } catch (e) {
      return false;
    }
  }
}
