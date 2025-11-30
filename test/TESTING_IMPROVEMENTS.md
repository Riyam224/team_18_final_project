# Testing Improvements Guide

This document outlines the improvements needed to achieve 100% test coverage and fix currently failing tests.

---

## Current Test Results

```
Total Tests: 232
Passing: 194 (83.6%)
Failing: 38 (16.4%)
```

---

## Failing Tests Analysis

### 1. Session Manager Stream Tests (2 failures)

**Files:** `test/core/security/session_manager_test.dart`

**Issue:** Stream emission tests timing out after 30 seconds

**Tests Affected:**
- `SessionManager should emit session state changes`

**Root Cause:**
The stream tests use `expectLater` with `emits()` but the stream might not be emitting values as expected, or the test is not properly subscribed before the emission occurs.

**Fix:**
```dart
test('should emit session state changes', () async {
  // Arrange
  when(() => mockEncryptionService.encrypt(any()))
      .thenAnswer((_) async => const Right('encrypted_data'));
  when(() => mockSecureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      )).thenAnswer((_) async => const Right(null));

  // Act
  final streamFuture = sessionManager.sessionStateStream.first;

  await sessionManager.startSession(
    userId: testUserId,
    token: testToken,
  );

  // Assert
  final emittedValue = await streamFuture.timeout(
    const Duration(seconds: 5),
    onTimeout: () => throw TimeoutException('Stream did not emit'),
  );
  expect(emittedValue, true);
});
```

---

### 2. App Lock Service Tests (3 failures)

**Files:** `test/core/security/app_lock_service_test.dart`

**Tests Affected:**
- `AppLockService should return true when locked (old activity)`
- `AppLockService should emit lock state changes`
- `AppLockService should unlock after activity update`

**Issue:** Timing-dependent tests not accounting for lock timeout properly

**Root Cause:**
The app lock service checks activity timestamp against a timeout duration. The mock needs to properly simulate time passage.

**Fix:**
```dart
test('should return true when locked (old activity)', () async {
  // Arrange
  // Create timestamp older than the default timeout (60 seconds)
  final oldTime = DateTime.now()
      .subtract(const Duration(minutes: 2)) // Ensure it's beyond timeout
      .millisecondsSinceEpoch
      .toString();

  when(() => mockSecureStorage.read(key: StorageKeysConfig.lastActivityTime))
      .thenAnswer((_) async => Right(oldTime));

  // Also mock timeout read to return default
  when(() => mockSecureStorage.read(key: StorageKeysConfig.autoLockTimeout))
      .thenAnswer((_) async => const Right('60')); // 60 seconds default

  // Act
  final result = await appLockService.isLocked();

  // Assert
  result.fold(
    (failure) => fail('Should not fail'),
    (isLocked) => expect(isLocked, isTrue),
  );
});
```

---

### 3. Encryption Service Import Issues (11 compilation errors)

**Files:** `test/core/security/encryption_service_test.dart`

**Issue:** Missing `dartz` import causing `Right` constructor not found

**Fix:** Already implemented - import added at the top of the file

---

## Missing Test Coverage

### Areas Needing Tests

#### 1. Data Layer Tests
**Priority:** High

Missing tests for:
- `lib/features/auth/data/repositories/auth_repository_impl.dart`
- `lib/features/auth/data/datasources/auth_local_datasource_impl.dart`
- `lib/features/transactions/data/repositories/transaction_repository_impl.dart`
- `lib/features/transactions/data/datasources/encrypted_transaction_data_source.dart`

**Example Test:**
```dart
// test/features/auth/data/repositories/auth_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockAuthLocalDataSource();
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('login', () {
    test('should return auth session on successful login', () async {
      // Test implementation
    });
  });
}
```

#### 2. Presentation Layer - Additional Cubits
**Priority:** Medium

Missing tests for:
- Biometric verify cubit complete coverage
- Additional home cubit scenarios
- Portfolio cubit (if exists)

#### 3. Use Cases
**Priority:** Medium

Missing tests for:
- `clear_transactions_usecase.dart`
- Any other domain use cases

**Example:**
```dart
// test/features/transactions/domain/usecases/clear_transactions_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late ClearTransactionsUseCase useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = ClearTransactionsUseCase(mockRepository);
  });

  test('should clear all transactions', () async {
    // Arrange
    when(() => mockRepository.clearTransactions())
        .thenAnswer((_) async => Future.value());

    // Act
    await useCase();

    // Assert
    verify(() => mockRepository.clearTransactions()).called(1);
  });
}
```

---

## Test Quality Improvements

### 1. Add More Edge Cases

**Current:** Basic happy path and error cases
**Needed:** More boundary conditions

Examples:
- Very large numbers in transactions
- Special characters in names/emails
- Network timeout scenarios
- Rapid successive calls
- Memory pressure scenarios

### 2. Improve Test Data Builders

Create test data builders for complex entities:

```dart
// test/helpers/test_builders.dart
class TransactionRecordBuilder {
  String _id = 'test_tx_id';
  String _type = 'buy';
  double _amount = 100.0;
  String _asset = 'BTC';
  DateTime _timestamp = DateTime.now();
  String? _note;

  TransactionRecordBuilder withId(String id) {
    _id = id;
    return this;
  }

  TransactionRecordBuilder withAmount(double amount) {
    _amount = amount;
    return this;
  }

  TransactionRecord build() {
    return TransactionRecord(
      id: _id,
      type: _type,
      amount: _amount,
      asset: _asset,
      timestamp: _timestamp,
      note: _note,
    );
  }
}

// Usage in tests:
final transaction = TransactionRecordBuilder()
    .withId('custom_id')
    .withAmount(999.99)
    .build();
```

### 3. Add Performance Tests

```dart
test('should encrypt data within acceptable time', () async {
  // Arrange
  final stopwatch = Stopwatch()..start();
  const testData = 'sensitive data';

  // Act
  await encryptionService.encrypt(testData);
  stopwatch.stop();

  // Assert
  expect(stopwatch.elapsedMilliseconds, lessThan(100)); // < 100ms
});
```

### 4. Add Stress Tests

```dart
test('should handle 1000 concurrent transactions', () async {
  // Arrange
  final futures = List.generate(1000, (i) =>
    TransactionRecord(
      id: 'tx_$i',
      type: 'buy',
      amount: i.toDouble(),
      asset: 'BTC',
      timestamp: DateTime.now(),
    )
  ).map((tx) => useCase(tx));

  // Act
  final results = await Future.wait(futures);

  // Assert
  expect(results.length, 1000);
});
```

---

## Integration Test Improvements

### 1. Add Real User Flow Tests

```dart
testWidgets('complete registration to transaction flow', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Navigate to registration
  await tester.tap(find.text('Sign Up'));
  await tester.pumpAndSettle();

  // Fill registration form
  await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
  await tester.enterText(find.byKey(Key('password_field')), 'Test123!');

  // Submit and verify home screen
  await tester.tap(find.text('Register'));
  await tester.pumpAndSettle();

  // Navigate to transactions
  // Add transaction
  // Verify transaction appears
});
```

### 2. Add Screenshot Tests

```dart
testWidgets('home screen matches golden', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();

  await expectLater(
    find.byType(HomeScreen),
    matchesGoldenFile('golden/home_screen.png'),
  );
});
```

---

## Code Coverage Goals

### Current Coverage by Layer
- Core: ~85%
- Domain: ~90%
- Data: ~70% ⚠️
- Presentation: ~75%

### Target Coverage
- Core: 95%
- Domain: 95%
- Data: 90% (needs improvement)
- Presentation: 85%

### How to Improve Coverage

1. **Generate Coverage Report**
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

2. **Identify Gaps**
Open `coverage/html/index.html` and look for:
- Red lines (not covered)
- Yellow lines (partially covered)
- Files with < 80% coverage

3. **Prioritize**
Focus on:
- Critical security code
- Business logic
- Data persistence
- Error handling paths

---

## Test Maintenance

### Regular Tasks

1. **Weekly:** Run full test suite
2. **Before each PR:** Ensure all tests pass
3. **Monthly:** Review and update test coverage
4. **Quarterly:** Refactor flaky/slow tests

### Test Health Metrics

Track these metrics:
- **Pass Rate:** Should be > 95%
- **Execution Time:** Unit tests < 2 minutes
- **Flakiness:** No tests should fail intermittently
- **Coverage:** Maintain > 85%

---

## Quick Wins

### Immediate Actions (< 1 hour)

1. ✅ Fix dartz import in encryption tests
2. ⏳ Fix timing in app lock tests
3. ⏳ Fix stream tests in session manager
4. ✅ Add transaction entity tests
5. ✅ Add clear transactions use case tests

### Short Term (< 1 day)

1. Add data layer tests
2. Add missing use case tests
3. Improve integration test coverage
4. Add test data builders

### Long Term (< 1 week)

1. Achieve 90% coverage across all layers
2. Add performance benchmarks
3. Add stress tests
4. Set up CI/CD test automation
5. Add golden tests for UI

---

## Resources

### Testing Tools
- `flutter_test`: Core testing framework
- `mocktail`: Mocking library
- `bloc_test`: BLoC testing utilities
- `integration_test`: Integration testing
- `golden_toolkit`: Screenshot testing

### Documentation
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [BLoC Testing](https://bloclibrary.dev/#/testing)

---

**Next Review Date:** 2025-12-07
