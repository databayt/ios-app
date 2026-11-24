# Changelog

All notable changes to the Hogwarts iOS app. Newest first.

The historical phase-by-phase reports referenced below live under
[`docs/history/`](docs/history/) and are kept for archeology, not as
canonical references — `docs/architecture.md` is the source of truth.

---

## Unreleased

### Navigation shell — the web's menu, the phone's drawer
- **One stack for the whole app.** `MainTabView` wraps the tab bar in a
  single `NavigationStack(path: $router.path)`; feature views no longer
  own stacks, so a tile, a menu row, a dashboard card and a push
  notification all push into the same place and back always leads home
  (`core/navigation/app-route.swift`).
- **`AppRoute` + `AppRouter`.** Typed routes named after the web pages
  they mirror, pushed from anywhere through the router in the
  environment. `AppRouteView` builds the screen and registers each
  feature's own destinations (`SubjectsRoute`, `ExamsRoute`,
  `ReportCardsRoute`, `FeesRoute`, `GuardianRoute`, `AdminRoute`,
  `AnnouncementsRoute`) so internal links resolve in the shared stack.
- **Platform menu.** `PlatformNav` is a literal port of the web
  sidebar's `config.ts` — order, keys, hrefs, roles and `alwaysVisible`
  — and `PlatformMenuView` renders it, role-filtered, from a toolbar
  button on the dashboard and the profile.
- **Href router + web handoff.** `HrefRouter` translates a web path to
  a native route and returns nil for pages the app has not rebuilt;
  those open on the school's own site through `WebHandoff`
  (`https://{subdomain}.balqalam.com/{lang}{path}?app=1`) in
  `InAppBrowserView`. No menu entry is a dead row.
- **App drawer.** `HomeTiles` + `AppTileGrid` put every feature one tap
  from the dashboard, role-filtered the way the drawer on Android is.

### Lumos — courses, lessons, quizzes, certificates
- **The learning platform, natively.** `features/lumos/` ports the web's
  `/lumos` screens against `/api/mobile/lumos/*`: the home shelves
  (start here, continue watching, recommended, featured), the course
  browser with grade shelves and 250 ms debounced typeahead search, the
  course page (curriculum, progress, enrol), the lesson page (player,
  mark-complete, quiz with per-question verdicts, resources, siblings,
  previous/next) and the certificate.
- **Paid courses stay on the web.** Enrol's `402` becomes
  `LumosError.paymentRequired`, and the course page offers the school's
  checkout page instead of pretending the purchase happened in-app.
- **Protected media.** `APIClient.resolveMediaURL` follows the signed
  redirect behind `/api/lumos/...` paths with the bearer token, so
  lesson videos and resource files play instead of 401-ing.
- Android's teacher-video and admin-review Lumos screens are
  deliberately not ported: `/api/lumos/videos/mine` and
  `/api/lumos/videos/pending` do not exist in the web app, and a screen
  that can only fail is worse than no screen.

### Tests
- `HogwartsTests/lumos/` pins the new behaviour: Lumos DTO decoding
  (including lenient fallbacks and quiz-answer encoding), the href
  router's page-by-page translation and role gates, the platform menu's
  order and visibility, the router's push/pop, the web handoff URL and
  the home tiles. Localization keys are added in en + ar (787 total).

### Engineering
- **Sync engine rewrite.** `core/storage/sync-engine.swift` now uses the
  correct `/mobile/*` endpoints, drops the redundant `schoolId` query
  param (the JWT carries it), surfaces failures via an observable
  `lastSyncError`, and replays queued offline mutations through new
  `APIClient.postRaw` / `putRaw` methods. The dangerous
  `extension Data: Encodable` shim is gone.
- **Auth restore reads `/mobile/profile`.** `AuthManager.restoreSession`
  installs a JWT-derived stub for an instant render, then upgrades to
  the canonical `User` from the network so cached fields like `nameAr`,
  `phone`, and `imageUrl` are no longer wiped on every cold launch.
- **Typed routing for push notifications.** `AppDelegate` now hops
  straight into `NotificationNavigationState.shared` instead of
  bouncing through `NotificationCenter`.
- **`APIClientProtocol` seam.** Lets `SyncEngine` and (over time)
  view models swap the live actor for a fake in tests.
- **Modern concurrency.** `AppDelegate.registerForPushNotifications`
  uses `Task { @MainActor in … }` instead of `DispatchQueue.main.async`.
  Build is now Swift 6.2 with strict concurrency = `complete` and
  `MainActor` as the default isolation; upcoming features
  `NonisolatedNonsendingByDefault` and `InferSendableFromCaptures`
  are enabled.
- **CI hardening.** `.github/workflows/build-test.yml` now runs
  SwiftLint as a strict gate, caches `DerivedData` and SPM artifacts,
  exports xcresult + coverage, archives on `main`, and runs on Xcode 26
  against an iOS 17 Pro simulator (iOS 26.4).

### Docs
- Phase reports moved from the repo root into `docs/history/`.
  `docs/architecture.md` and `docs/apple-design-guidelines.md` remain
  the canonical reference docs.

---

## 2026-02-10 — Phase 6 audit & build verification

Final audit + simulator build verification. 14/15 quality checks passed;
Liquid Glass adoption complete across 11 feature modules. See
[`docs/history/PHASE_6_AUDIT_SUMMARY.md`](docs/history/PHASE_6_AUDIT_SUMMARY.md)
and
[`docs/history/SIMULATOR_BUILD_VERIFICATION.md`](docs/history/SIMULATOR_BUILD_VERIFICATION.md).

## 2026-02-10 — Phase 2C: detail views

Detail views migrated to glass materials and continuous corners. See
[`docs/history/PHASE_2C_COMPLETION.md`](docs/history/PHASE_2C_COMPLETION.md).

## 2026-02-10 — Phase 2B: forms

Forms wrapped with inset-grouped sections and standardized sheet
presentation. See
[`docs/history/PHASE_2B_SUMMARY.md`](docs/history/PHASE_2B_SUMMARY.md)
and
[`docs/history/CONTINUATION_PROGRESS.md`](docs/history/CONTINUATION_PROGRESS.md).

## 2026-02-10 — Apple design language transformation

iOS 26 visual language adopted across 11 modules: Liquid Glass,
continuous corners, native navigation patterns, design tokens. See
[`docs/history/IMPLEMENTATION_COMPLETE.md`](docs/history/IMPLEMENTATION_COMPLETE.md)
and
[`docs/history/TRANSFORMATION_COMPLETE.md`](docs/history/TRANSFORMATION_COMPLETE.md).
