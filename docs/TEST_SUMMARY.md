# Test Summary (Current State)

- **Unit/Widget Focus**: Auth use cases and cubit, validators (email/name/password/phone), UI buttons, home cubit, and transactions domain use cases/entities.
- **Integration Tests** (`integration_test/`): Auth flow, app navigation, security flow, and transaction flow.
- **Skipped Suites**: Hardware/platform-dependent tests (`app_lock_service_test.dart`, `session_manager_test.dart`, `root_detection_service_test.dart`, `biometric_service_test.dart`, `screenshot_prevention_service_test.dart`) are annotated with `@Skip` until proper platform mocking is added.
- **Recent Validation Updates**: Email/password/name/phone validators now trim input; password validation enforces uppercase, lowercase, number, and special character requirements.
- **UI Flow Changes Under Test**: Splash → onboarding/login routing and biometric flows use shared `TimingConfig` delays (no inline durations).

Run everything with `flutter test` (unit/widget) and `flutter test integration_test/` (integration).
