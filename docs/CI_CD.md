# CI/CD

Recommended GitHub Actions pipeline and branching model for this repo.

## Pipeline (GitHub Actions)
Suggested workflow file: `.github/workflows/ci.yml`

Steps:
1. **Checkout & Flutter setup** – cache pub + Gradle.
2. **Static checks** – `flutter format --set-exit-if-changed .` and `flutter analyze`.
3. **Tests** – `flutter test --coverage`; upload `coverage/lcov.info` as artifact.
4. **Optional integration** – `flutter test integration_test` on device/emulator runners.

Example matrix (condensed):
```yaml
name: CI
on: [pull_request, push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: {flutter-version: '3.x'}
      - run: flutter pub get
      - run: flutter format --set-exit-if-changed .
      - run: flutter analyze
      - run: flutter test --coverage
      - uses: actions/upload-artifact@v4
        with:
          name: coverage-lcov
          path: coverage/lcov.info
```

## Branching Model (GitFlow)
- `main`: production-ready. Protected; release tags cut here.
- `develop`: integration branch for the next release.
- `feature/*`: short-lived branches per feature; rebase/merge into `develop`.
- `release/*`: stabilization; hotfix into `main` and back-merge to `develop`.
- `hotfix/*`: emergency fixes off `main`.

## Required Checks (before merge)
- Formatter + analyzer pass.
- Unit tests (and integration tests when enabled) green.
- Coverage artifact generated; optionally enforce minimum threshold via coverage gate.
- No `TODO`/`FIXME` in new code for security-sensitive areas unless ticketed.

## Environments & Secrets
- `COINGECKO_API_KEY` as `--dart-define` if market data needs authenticated quota.
- Firebase config (GoogleService-Info.plist/google-services.json) managed via secure secrets/ENV or build-time injection; never checked into the workflow logs.
- If using emulator tests, provide AVD setup or use `reactivecircus/android-emulator-runner`.

## Release Checklist
- Bump version & changelog.
- Run `flutter analyze` and `flutter test --coverage`.
- Ensure `docs/SECURITY_FEATURES_OVERVIEW.md` is up to date (mandatory).
- Tag release and attach built artifacts if distributing (e.g., `flutter build apk/ipa`).
