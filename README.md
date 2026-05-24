# Hogwarts iOS

Native iOS companion app for the Hogwarts school management platform.

## Tech Stack

- **Swift 6.2** with strict concurrency (default actor isolation = `MainActor`)
- **SwiftUI** + `@Observable` (no `ObservableObject`)
- **iOS 18+** deployment target, **Xcode 26** + **iOS 26.4 SDK** required for builds (Liquid Glass, AppShortcuts)
- **SwiftData** — versioned schema, offline-first cache
- **Swift Testing** (`@Test`) for unit tests; XCTest stays for UI tests
- **String Catalogs** (`Localizable.xcstrings`) — Arabic (default, RTL) + English

## Quick Start

```bash
# Generate the project (idempotent)
brew install xcodegen swiftlint xcbeautify
xcodegen generate

# Open in Xcode
open Hogwarts.xcodeproj

# Build + test from CLI (requires the iOS 26.4 platform installed via
# Xcode → Settings → Components)
xcodebuild test \
  -scheme Hogwarts \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.4' \
  -only-testing:HogwartsTests \
  | xcbeautify
```

## Architecture

### Mirror pattern

The folder layout mirrors the Hogwarts web app feature-for-feature so the
two clients evolve together. Within each feature folder:

```
features/{feature}/
├── views/        # *-content.swift (main), forms, tables, role views
├── viewmodels/   # @Observable @MainActor view models
├── services/     # *-actions.swift — calls /mobile/* via APIClient
├── models/       # Codable DTOs + @Model SwiftData entities
└── helpers/      # validation, types, navigation routers
```

### Core layer

```
core/
├── network/      # APIClient (actor) + APIClientProtocol seam,
│                 # NetworkMonitor (@MainActor @Observable)
├── storage/      # DataContainer (SwiftData), SyncEngine
├── auth/         # AuthManager (DI-friendly), KeychainServicing seam,
│                 # BiometricService, TenantContext
└── extensions/   # Logger categories
```

### SyncEngine — offline-first

`SyncEngine` is `@MainActor @Observable`. It refreshes the three
cross-cutting reference entities (`students`, `conversations`,
`notifications`) on launch and on silent push, and replays the
`PendingAction` mutation queue when the network comes back. Per-user
data (attendance, grades, timetable) is fetched on demand by feature
view models, which do their own offline-first cache reads.

State (`isSyncing`, `lastSyncCompletedAt`, `lastSyncError`) is observable
directly — no `NotificationCenter` bridge — so `SyncStatusBanner` and
any view can read the current state and the user can tap the error
banner to retry.

### Routing

Push-notification deep links flow straight from `AppDelegate` into
`NotificationNavigationState.shared` (a `@MainActor @Observable`
singleton). No `NotificationCenter` round-trip. The TabView binds to
`selectedTab`; per-screen deep destinations land in `pendingDestination`
for views to consume on appear.

### App Shortcuts (iOS 18+)

`HogwartsAppShortcuts` registers Siri / Spotlight / app-icon-long-press
intents:

- **Open Dashboard**
- **Today's Schedule**
- **Open Messages**
- **Mark Attendance**

Each just flips `NotificationNavigationState.shared.selectedTab` — the
launch hand-off does the rest.

## Multi-tenant safety

The JWT carries `schoolId`. The mobile API reads it from the token and
scopes every query server-side. **Do not pass `schoolId` as a query
param** — the backend ignores it.

```swift
// Right
try await api.get("/mobile/students", as: StudentsResponse.self)

// Wrong — schoolId leaks intent that the server doesn't honor
try await api.get("/mobile/students", query: ["schoolId": id], as: ...)
```

## Localization

Source language: **Arabic (RTL)**. English is the secondary locale.
All strings live in `hogwarts/resources/Localizable.xcstrings`. Use
`String(localized: "key")`; never embed raw English (or Arabic) text
inside a view.

Layout uses logical edges (`.leading`/`.trailing`, `.padding(.leading,)`)
so SwiftUI auto-mirrors. The in-app language toggle writes to
`@AppStorage("selectedLanguage")` and `HogwartsApp` flips
`\.layoutDirection` accordingly without an app relaunch.

## Testing

Unit tests use **Swift Testing** (`@Test`, `#expect`) and live next to
the feature they cover. The `MockAPIClient` in
`HogwartsTests/sync-engine-mock-tests.swift` is the canonical stub —
it conforms to `APIClientProtocol`, records every call, and supports
`stubEmpty` / `stubFailure` / `installSuccess` / `stubRawSuccess`.

```bash
xcodebuild test \
  -scheme Hogwarts \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.4' \
  -only-testing:HogwartsTests/SyncEngineMockTests \
  -only-testing:HogwartsTests/AuthManagerRestoreTests \
  | xcbeautify
```

UI tests stay on **XCTest** in `HogwartsUITests/`.

**Target**: 80% line coverage on `core/` + every feature's `services/`
and `viewmodels/`.

## CI

`.github/workflows/build-test.yml` runs three jobs:

1. **`lint`** — `swiftlint --strict` (gates the rest)
2. **`build-and-test`** — Xcode 26, iPhone 17 Pro / iOS 26.4 simulator,
   DerivedData + SPM caching, `xcbeautify` output, coverage uploaded
   to Codecov, `xcresult` archived as a build artifact.
3. **`archive`** — Release-config xcarchive on every push to `main`,
   uploaded as an artifact for TestFlight handoff.

## Design language

iOS 26 Liquid Glass + Apple HIG. See [Apple Design Guidelines](docs/apple-design-guidelines.md).

- `.glassEffect()` and `GlassEffectContainer` on the navigation layer
  (toolbars, sheets, floating actions) — never on content rows.
- Continuous-corner `RoundedRectangle(... style: .continuous)`.
- Materials (`.ultraThinMaterial`, `.thinMaterial`, `.regularMaterial`)
  for translucent surfaces; honor `accessibilityReduceTransparency`.
- SF Symbols 6 with hierarchical rendering and `.symbolEffect(...)`.
- Dynamic Type via semantic font sizes (`.title2`, `.body`, `.caption`).

## TestFlight distribution

```bash
# Requires Apple Developer Team ID
./scripts/archive-for-testflight.sh YOUR_TEAM_ID
```

See [TestFlight Distribution](docs/testflight-distribution.md).

## Documentation

- [CHANGELOG](CHANGELOG.md) — what changed and why
- [PRD](docs/prd.md) — product requirements
- [Architecture](docs/architecture.md) — canonical technical reference
- [Apple Design Guidelines](docs/apple-design-guidelines.md) — design system
- [TestFlight Distribution](docs/testflight-distribution.md) — beta setup
- [docs/history/](docs/history/) — phase-by-phase progress reports
  (kept for archeology, not as canonical references)

## Related

- [Hogwarts Web](https://ed.databayt.org) — Web platform, source of truth
  for business logic. Mobile API at `/api/mobile/*`.
- [Hogwarts Android](https://github.com/databayt/kotlin-app) — Sibling
  Kotlin app; iOS mirrors its module boundaries and architectural
  patterns where they translate (StateFlow → `@Observable`, Hilt →
  factory init with default args, Room → SwiftData).
