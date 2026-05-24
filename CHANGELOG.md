# Changelog

All notable changes to the Hogwarts iOS app. Newest first.

The historical phase-by-phase reports referenced below live under
[`docs/history/`](docs/history/) and are kept for archeology, not as
canonical references — `docs/architecture.md` is the source of truth.

---

## Unreleased

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
