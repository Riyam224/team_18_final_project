class ScreenshotPrevention {
  // Screenshot blocking is handled natively in MainActivity.kt
  static Future<void> block() async {}

  static Future<void> allow() async {
    // Cannot disable FLAG_SECURE at runtime once enabled globally.
  }
}
