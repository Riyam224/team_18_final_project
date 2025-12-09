import 'package:flutter_test/flutter_test.dart';

/// Shared deterministic timestamp used across portfolio tests.
final DateTime fixedNow = DateTime.utc(2024, 1, 15, 12, 0, 0);

/// Convenience for asserting doubles without flaky precision errors.
void expectClose(double actual, double expected, {double delta = 1e-6}) {
  expect(actual, closeTo(expected, delta));
}
