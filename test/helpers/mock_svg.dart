import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Provides a fake SVG asset for widget tests to avoid asset bundle lookups.
Future<void> registerSvgMock({String assetContent = _defaultSvg}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fakeBytes = Uint8List.fromList(utf8.encode(assetContent));
  ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
    'flutter/assets',
    (message) async {
      final key = utf8.decode(message!.buffer.asUint8List());
      if (key.toLowerCase().endsWith('.svg')) {
        return ByteData.view(fakeBytes.buffer);
      }
      return null;
    },
  );
}

const _defaultSvg =
    '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">'
    '<circle cx="12" cy="12" r="10" fill="currentColor"/></svg>';
