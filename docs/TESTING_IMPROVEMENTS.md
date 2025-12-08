# Testing Improvements Checklist

- Add platform mocks for security services (app lock, session manager, root detection, biometrics, screenshot prevention) to un-skip the currently hardware-gated suites.
- Expand integration coverage for updated onboarding/splash/login routing and biometric success/failure paths using the shared `TimingConfig` delays.
- Add regression tests for first-name greeting on Home (secure storage fallback to email username) and for onboarding completion flag transitions.
- Consider lightweight golden/interaction tests for key auth screens if UI changes continue.
