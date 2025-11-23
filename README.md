Perfect! I’ll rewrite your README.md into a **clean, short, professional, company-level README** — and move all long sections into the docs/ folder.

Here is the **rewritten README.md** exactly as it should look in a real production repository 👇

---

# ✨ **Team 18 Final Project – Fintech App**

A modern Flutter fintech application built with clean architecture, powerful theming, robust API integration, and scalable feature modules.
Designed for learning, collaboration, and real-world engineering practices.

---

## 📌 **Table of Contents**

* [Overview](#overview)
* [Tech Stack](#tech-stack)
* [Key Features](#key-features)
* [Project Structure](#project-structure)
* [Getting Started](#getting-started)
* [Environment Variables](#environment-variables)
* [Developer Guidelines](#developer-guidelines)
* [Git Workflow](#git-workflow)
* [Documentation](#documentation)

---

## 🚀 **Overview**

This project is a full fintech mobile application built using Flutter with:

* Clean Architecture (presentation → domain → data → core)
* GoRouter for navigation
* Dio + Retrofit for networking
* Full theme system (light/dark)
* Feature-based folder structure
* Automatic dependency injection using GetIt
* SharedPreferences for local storage
* Modular, scalable UI components

The app integrates with **CoinGecko API** to fetch live crypto market data.

---

## 💻 **Tech Stack**

### **Frontend**

* Flutter 3.x
* Dart 3.x
* Flutter BLoC / Provider
* GoRouter
* Dio + Retrofit
* ScreenUtil
* SharedPreferences

### **Architecture**

* Clean Architecture
* Repository Pattern
* Dependency Injection (GetIt)
* Functional Error Handling (Failure classes)

---

## ⭐ **Key Features**

* **Splash Screen** with animated logo + smart navigation
* **4-page Onboarding Flow** with skip, next, and final CTA
* **Theming System**: fully customizable light & dark mode
* **Market Module** reading data from CoinGecko API
* **Dynamic Routing** using GoRouter
* **Reusable UI Components** across the whole app
* **Error Handling Layer** for API + cache failures

---

## 📁 **Project Structure**

```
lib/
├── core/               # Global resources (theme, routing, errors, networking, DI)
├── features/           # All app features (modular + scalable)
│   ├── splash/
│   ├── onboarding/
│   ├── home/
│   ├── market/
│   ├── portfolio/
│   ├── auth/
│   └── settings/
└── main.dart           # App entry point
```

This structure follows **Clean Architecture** and supports large-team collaboration.

---

## 🛠️ **Getting Started**

### 1. Clone the repo

```bash
git clone <repository-url>
cd team_18_final_project
```

### 2. Install packages

```bash
flutter pub get
```

### 3. Run the app

Without API key (limited features):

```bash
flutter run
```

With CoinGecko API key (recommended):

```bash
flutter run --dart-define=COINGECKO_API_KEY=your_key_here
```

---

## 🔐 **Environment Variables**

The app uses **compile-time environment variables**:

| Key                 | Required | Description                         |
| ------------------- | -------- | ----------------------------------- |
| `COINGECKO_API_KEY` | Optional | Used for authenticated API requests |

**Example run:**

```bash
flutter run --dart-define=COINGECKO_API_KEY=abc123
```

---

## 🧩 **Developer Guidelines**

### Code Style

* Follow Flutter/Dart conventions
* Use `flutter_lints`
* Avoid hardcoded strings/colors → use constants from core

### Branch Naming

```
feature/home_screen
feature/market_api
fix/navigation_bug
docs/update_readme
```

### Commit Message Format

```
feat: add onboarding UI
fix: resolve bottom nav crash
docs: create splash documentation
style: apply formatting
refactor: extract reusable widgets
```

---

## 🔀 **Git Workflow**

1. Create a branch from `develop`
2. Implement your feature
3. Push and open a Pull Request
4. At least **1 reviewer** must approve
5. Merge into `develop`

Your team uses **GitFlow**:

* `main` → stable release
* `develop` → active development
* `feature/*` → new features
* `bugfix/*` → fixes
* `hotfix/*` → production emergencies

---

## 📚 **Documentation**

All detailed documentation is located in the `docs/` folder:

```markdown
## 📘 Full Documentation

- [Splash Feature](docs/splash.md)
- [Onboarding Feature](docs/onboarding.md)
- [Theming System](docs/theming.md)
- [Networking Layer](docs/networking.md)
- [Routing System](docs/routing.md)
- [Core Architecture](docs/architecture.md)
- [Home Feature](docs/home.md)
- [Market Feature](docs/market.md)
- [Portfolio Feature](docs/portfolio.md)
- [Troubleshooting](docs/troubleshooting.md)
```


---

## 🏷️ **Project Details**

**Team:** Team 18
**Branch:** develop
**Platform:** Flutter

---
