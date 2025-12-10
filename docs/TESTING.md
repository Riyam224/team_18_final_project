# Testing

How to test this codebase and the conventions we follow.

## Structure
- `test/core/security/*`: encryption, biometric, session, app-lock, screenshot prevention, root detection.
- `test/core/validation/*`: input validators.
- `test/features/portfolio/*`: portfolio domain/presentation helpers.
- `test/support/*`: reusable fakes (secure storage, biometrics, session manager) and helpers.
- `integration_test/`: end-to-end harness (runs app entrypoint in test env).

## Environment & DI
- Tests bootstrap DI via `test/test_config.dart`, which calls:
  ```dart
  setupDependencies(
    env: AppEnvironment.test,
    securityOverrides: createTestSecurityOverrides(),
  );
  ```
- `createTestSecurityOverrides()` supplies in-memory/no-op implementations for security services to avoid platform channel calls.
- Keep Cubit constructors side-effect free; trigger network/IO via explicit `load()`/`verify()` in tests.

## Running Tests
```bash
flutter test                    # unit/widget
flutter test integration_test   # integration harness
flutter test --coverage         # generates coverage/lcov.info
```

To view coverage locally (requires lcov):
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Mocks & Fakes
- Use fakes in `test/support/test_security_fakes.dart` for `ISecureStorage`, `ISessionManager`, `IAppLockService`, `IBiometricService`, etc.
- For portfolio/domain tests, use helper fixtures in `test/helpers/test_portfolio_data.dart` and fake repositories in `test/helpers/fake_portfolio_repository.dart`.
- Prefer stubs/fakes over heavy mocks; when mocking, keep expectations on repository interfaces (domain contracts), not concrete data sources.

## Example: Session Manager Test
```dart
void main() {
  late ISessionManager session;

  setUp(() {
    session = SessionManagerImpl(
      secureStorage: InMemorySecureStorage(),
      encryptionService: FakeEncryptionService(),
    );
  });

  test('expires after configured timeout', () async {
    await session.startSession(userId: 'u', token: 't', customTimeout: Duration(seconds: 1));
    await Future.delayed(const Duration(seconds: 2));
    final valid = await session.isSessionValid();
    expect(valid.getOrElse(() => true), isFalse);
  });
}
```

## Philosophy
- **Test the seams**: Use cases, repositories, and Cubits should be covered; UI widget tests for critical screens (login, app-lock, home loading).
- **Deterministic**: Avoid relying on real timers/platform channels; inject fakes and control clocks when possible.
- **Security-critical paths first**: biometrics, session expiry, auto-lock, secure storage correctness.
- **Happy + unhappy paths**: cover failure mapping (e.g., `AuthFailure` → user message), and caching fallbacks (home/portfolio).
- **Minimal snapshot testing**: prefer asserting on state objects and rendered widgets rather than pixel-perfect matches.
