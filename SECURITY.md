# Security Overview

This document summarizes how security, authentication, and privacy protections are wired in the app, and where to extend them.

## Launch & Auth Flow
```mermaid
flowchart TD
  A[App launch] --> B[setupDependencies()]
  B --> C[RootDetectionService.performSecurityCheck()]
  C --> D[SessionManager.initialize() + restore]
  D --> E[SplashScreen]
  E -->|hasValidSession| H[Home]
  E -->|onboarding not done| F[Onboarding]
  E -->|biometric enabled + available| G[Biometric login route]
  E -->|fallback| L[Login/Register]
  H --> I[SessionManager.startSession + activity tracking]
```

## Runtime Protection Flow
```mermaid
flowchart LR
  U[User interaction] --> A[AppLockService.updateActivity()]
  A --> S[SessionManager.updateActivity()]
  S --> V[Session validity check]
  V -->|expired| X[Logout + navigate /login]
  subgraph Lifecycle
    BG[App to background] --> BLUR[SecureApplication blur + screenshot block]
    BG --> TS[Persist last activity]
    FG[App resume] --> RC[SessionManager.checkSessionValidity()]
    FG --> LC[AppLockService.shouldLock()]
    LC -->|timeout| AL[/Navigate to /app-lock/]
  end
  AL --> LA[LocalAuthService.authenticate()]
  LA -->|success| H[Return to app]
```

## Key Services (where to extend)
- `lib/core/security/secure_storage_service.dart`: encrypted storage for tokens, biometrics, session timestamps.
- `lib/core/security/session_manager.dart`: session start/restore, expiry, and callbacks for auto-logout.
- `lib/core/security/app_lock_service.dart`: inactivity auto-lock (uses stored timestamps and configurable timeout).
- `lib/core/security/local_auth_service.dart`: biometric availability + authentication helpers.
- `lib/core/security/root_detection_service.dart`: startup device integrity checks.
- `lib/core/observers/app_route_observer.dart`: toggles blur + screenshot blocking on sensitive routes.

## Splash/Onboarding Behavior
- Splash now short-circuits to **Home** when a stored session is still valid.
- If onboarding is complete but no active session, splash routes to biometric login when enabled and available, otherwise to the credentials login screen.
- Onboarding remains the default path for first-time users.

## Usage Reminders
- Always call `SessionManager.startSession()` after successful auth (email/password or biometrics) so session timeout is enforced.
- Update activity on sensitive actions if you introduce long-running flows to avoid premature auto-lock (`AppLockService.updateActivity()` and `SessionManager.updateActivity()`).
- Add new sensitive routes to `sensitiveRoutes` in `app_route_observer.dart` to keep screenshots blocked.
- Keep timeouts user-configurable via settings screens by wiring to `setSessionTimeout()` and `setAutoLockTimeout()`.

## Quick Testing Checklist
- Login → verify session starts and user stays logged in across cold start while within timeout window.
- Background/resume after timeout → app should auto-lock or logout based on configured durations.
- Navigate to sensitive routes (portfolio/payment/etc.) → screenshots should be blocked.
- Biometric enabled → splash should send you to biometric login; disable biometrics → splash should send you to credentials login.
