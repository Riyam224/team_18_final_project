# Tests Overview

This project uses Flutter unit, widget, and integration tests to cover core flows. Integration tests live in the root-level `integration_test/` directory (per Flutter convention), while unit/widget tests live under `test/`.

## Structure
- `test/core` – validation, UI widgets, and security/service units
- `test/features` – feature-specific domain and presentation tests (auth, home, transactions)
- `integration_test/` – end-to-end flows (auth, navigation, security, transactions)

## Running
- All unit/widget tests: `flutter test`
- Specific test file: `flutter test test/features/auth/domain/usecases/login_user_usecase_test.dart`
- Integration tests: `flutter test integration_test/`

## Notes
- Hardware/platform-dependent suites (`app_lock_service_test.dart`, `session_manager_test.dart`, `root_detection_service_test.dart`, `biometric_service_test.dart`, `screenshot_prevention_service_test.dart`) are marked with `@Skip('Skipped – depends on hardware/platform and must be mocked')`.
- Validation tests assert the current trimmed input behavior and stricter password rules (uppercase/lowercase/number/special).
- Tests bootstrap a test-safe DI graph via `test/test_config.dart` (AppEnvironment.test); integration tests invoke `main(env: AppEnvironment.test, securityOverrides: createTestSecurityOverrides())`.
