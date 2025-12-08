import 'dart:async';

import 'package:team_18_final_project/core/di/di.dart';

import 'support/test_security_fakes.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await setupDependencies(
    env: AppEnvironment.test,
    securityOverrides: createTestSecurityOverrides(),
  );

  return runZoned(
    () async => await testMain(),
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        // suppress prints in test output
      },
    ),
  );
}
