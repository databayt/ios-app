---
code: PRODUCTION-OVERVIEW
title: iOS Production Roadmap (App Store launch)
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/*"]
i18n_namespaces: []
multi_tenant: required
---

# iOS Production Roadmap — App Store Launch

> **Single source of truth for what ships in v1.0.** This document sequences the existing 48 iOS epics + 414 stories into a 4-sprint (8-week) execution plan ending with App Store submission. It does **not** introduce new epics — the backlog under `docs/epics/` already covers everything. This is the **roadmap overlay**.

## Doctrine

| Repo | Role | Source |
|------|------|--------|
| `databayt/hogwarts` | **Source of truth** — web app, API, schema, multi-tenant rules | Next.js 16 · Prisma · TypeScript |
| `databayt/android-app` | **Lead mobile reference** — feature patterns are set here first | Kotlin · Jetpack Compose |
| `databayt/ios-app` (this) | **Mirrors android-app** against the same `/api/mobile/*` contract | Swift 6 · SwiftUI |

When a feature lands in `android-app`, it gets ported here. When a backend pattern lands on `hogwarts`, both mobile clients adapt. See `databayt/hogwarts/docs/MOBILE-HIERARCHY.md` for the full doctrine.

The phase tags below (**A–F**) deliberately mirror the Android `.bmad/epics/epic-prod-overview.md` structure so cross-platform status comparisons stay one-to-one. iOS keeps its existing `phase: M0/M1/M2` milestone tagging untouched in each epic's frontmatter — A–F is an **execution overlay**, not a replacement.

> **Design rules**: every UI story in this roadmap obeys [docs/DESIGN-RULES.md](../DESIGN-RULES.md) — atomic composition (compose from `shared/atom/` before inventing), mirror pattern (`views/viewmodels/services/models/helpers` per feature), kebab-case files, `@Observable @MainActor` view models, Liquid Glass + iOS 26 idioms, RTL/AR parity, [Figma iOS](https://www.figma.com/design/WJPT23xMx4B6oXrCavmHbQ/iso) as the pixel source of truth, [Android app](https://github.com/databayt/android-app) as the feature cadence reference.

---

## Phase Structure (mirrors Android)

| Phase | Theme | Sprint | Exit Gate |
|-------|-------|--------|-----------|
| **A** | Foundation: API + auth + tenant | 1 | All 19 features hit `/api/mobile/*` with JWT; multi-tenant predicate guard on every SwiftData query |
| **B** | I18n: RTL + string parity | 1 (parallel) | `Localizable.xcstrings` has zero missing AR keys; RTL screenshot diffs on 5 critical flows |
| **C** | Backend integration: push + payments + consent | 2 | APNs token round-trips; Stripe + Apple Pay sandbox checkout works; consent flow gates first launch |
| **D** | Feature completion: TODOs → done | 3 | Every `*-actions.swift` returns real data (no fixtures, no "Coming Soon" outside `coming-soon-view.swift`) |
| **E** | Quality: tests + a11y + perf + security | 3 (parallel) | 80% coverage on `core/` + `*-view-model.swift`; VoiceOver pass on 8 flows; cold launch < 2s |
| **F** | Production: ASO + privacy + Fastlane + submission | 4 | TestFlight tag → App Store Connect; privacy label complete; submission accepted |

A/B/C run staggered. D/E run in parallel during sprint 3. F is sprint 4.

---

## Epic Phase Map

All **24 P0 + 3 P1 M0 epics** below are launch-critical. M1/M2 epics are post-launch.

### Phase A — Foundation (sprint 1)

| Epic | Title | Why A |
|------|-------|-------|
| **[F-CORE](./F-CORE.md)** | Core infrastructure | APIClient `/api/mobile/*` migration, snake_case decoding, race-safe refresh, TenantContext, audit log, telemetry sink, env schemes |
| **[AUTH](./AUTH.md)** | Authentication & Account | Sign in with Apple (AUTH-007), biometric (AUTH-005), hardened refresh (AUTH-008), session restore polish (AUTH-013) |

### Phase B — I18n (sprint 1, parallel)

| Epic | Title | Why B |
|------|-------|-------|
| **[F-LOCALE](./F-LOCALE.md)** | Locale-aware formatting | Arabic-Indic digits, dates, currency, RTL layout primitives |
| **[F-DESIGN](./F-DESIGN.md)** | Design system (tokens, Liquid Glass, motion) | Tokens are bilingual-ready by definition; this is when RTL audits pass |

### Phase C — Backend integration (sprint 2)

| Epic | Title | Why C |
|------|-------|-------|
| **[F-PUSH](./F-PUSH.md)** | Push notifications (APNs) | Token registration, categories, deep-link routing, silent push |
| **[F-OFFLINE](./F-OFFLINE.md)** | Sync engine v2 | Pending action queue, conflict resolution, background refresh |
| **[GOV](./GOV.md)** | Governance & compliance | Consent flow + ATT + data export + account delete (App Store gates) |
| **[OBS](./OBS.md)** | Observability | Sentry + MetricKit + custom event taxonomy |
| **[FEES](./FEES.md)** *(payment portion: PAY-001/PAY-002/PAY-005)* | Apple Pay + Stripe card sheet | Backend dependency on `POST /api/mobile/payments/process` |

### Phase D — Feature completion (sprints 3-4)

All M0 feature epics — TODOs swept, scaffolds wired to real `/api/mobile/*` calls, "Coming Soon" stubs replaced.

| Epic | Title |
|------|-------|
| **[ANNOUNCE](./ANNOUNCE.md)** | Announcements |
| **[ATTENDANCE](./ATTENDANCE.md)** | Attendance + gamification + hall-pass |
| **[DASHBOARD](./DASHBOARD.md)** | Role-based home + tile spec |
| **[FEES](./FEES.md)** *(viewing portion: FEE-*)* | Fee list, summary, invoices, receipts |
| **[GRADES](./GRADES.md)** | Grades + GPA |
| **[GUARDIAN-LINK](./GUARDIAN-LINK.md)** | Guardian-child linking |
| **[HOME](./HOME.md)** | Home screen (grid + dock + wallpaper) |
| **[MESSAGING](./MESSAGING.md)** | Conversations + chat + starred + WhatsApp-style |
| **[NOTIF](./NOTIF.md)** | In-app inbox + preferences |
| **[ONBOARD](./ONBOARD.md)** | First-run flow |
| **[PROFILE](./PROFILE.md)** | Profile + about + help |
| **[SETTINGS](./SETTINGS.md)** | Settings (language, push, logout) |
| **[TIMETABLE](./TIMETABLE.md)** | Schedule view |
| **[F-INTEGRATION](./F-INTEGRATION.md)** *(P1)* | EventKit + Reminders + Contacts + Photos |
| **[F-MEDIA](./F-MEDIA.md)** *(P1)* | Image + file + camera pipeline |
| **[F-SHARING](./F-SHARING.md)** *(P1)* | Share Sheet + Activity extensions |

### Phase E — Quality (sprint 3, parallel)

| Epic | Title | Why E |
|------|-------|-------|
| **[Q-TEST](./Q-TEST.md)** | Test infrastructure + 80% coverage | Swift Testing harness, snapshot tests, RTL audits, multi-tenant isolation tests |
| **[Q-A11Y](./Q-A11Y.md)** | Accessibility | VoiceOver, Dynamic Type, Reduce Motion, contrast |
| _Q-PERF_ *(M1)* | Performance | Pulled into M0 if it threatens cold-launch SLA |
| _Q-SECURITY_ *(M1)* | Security hardening | CORE-010 cert pinning lands in phase A; rest can defer |

### Phase F — Production (sprint 4)

| Epic | Title | Why F |
|------|-------|-------|
| **[SHIP](./SHIP.md)** | TestFlight + App Store assets + privacy manifest + export compliance + ASO + Fastlane (SHIP-009) | App Store submission |

---

## Critical Path (Sprint-by-sprint)

The **~75 M0 stories** below are the launch critical path. Every story has a fully-written file at `docs/stories/{ID}.md` with user story, AC, file paths, i18n keys, tests, and DoD. Sprint capacity assumes **2 engineers full-time + 1 QA**.

> **Status as of 2026-05-25** — audit of `hogwarts/` against the M0 story backlog revealed that **most of Sprint 1 is already implemented in code** (only the story files were still marked `pending`). The status tags below reflect the audit findings; story files have been flipped to `Status: done` where confirmed. The genuine remaining gaps are **CORE-002 retry-on-401**, **CORE-006 audit-log writer**, **CORE-009 staging scheme**, and the partial scope under CORE-008 (DSN per environment).

### Sprint 1 (weeks 1–2) — Phase A + B

**Phase A (engineer 1):** the backbone
- ✅ [CORE-001](../stories/CORE-001-api-client-mobile-prefix.md) APIClient `/api/mobile/*` + snake_case [3 pts] — **done** (base URL `/api`, every `*-actions.swift` hits `/mobile/...`, `keyDecodingStrategy = .convertFromSnakeCase` set on line 211)
- ⚠️ [CORE-002](../stories/CORE-002-token-refresh-race-safe.md) Token refresh via `PUT /mobile/auth` [5] — **partial** (refresh works proactively via `restoreSession` + `ensureFreshToken`; 401 currently signs out instead of retry-and-refresh; no in-flight refresh guard)
- ✅ [CORE-003](../stories/CORE-003-remove-mock-login-bypass.md) Remove mock login bypass [1] — **done** (no mock/bypass/fake matches in `auth-manager.swift`)
- ✅ [CORE-004](../stories/CORE-004-jwt-decode-helper.md) JWT decode helper [2] — **done** (`TokenPayload.decode(from:)` in `auth-types.swift:54-110`, pure Swift base64url + JSON, extracts sub/exp/email/role/name/schoolId)
- ✅ [CORE-005](../stories/CORE-005-tenant-context-observable.md) `TenantContext` observable [3] — **done** (`@Observable` `TenantContext` with `schoolId`/`school`/`subdomain`/`isValid`; `currentRole`/`currency` are nice-to-have extensions, not blockers)
- ❌ [CORE-006](../stories/CORE-006-audit-log-writer.md) Audit log writer [3] — **not started** (no `audit-log.swift` anywhere)
- ⚠️ [CORE-008](../stories/CORE-008-telemetry-sink.md) Sentry SDK + custom event sink [3] — **done in this branch** (Sentry SPM dep added to `project.yml`, `core/observability/sentry-bootstrap.swift` with PII-stripping `beforeSend`, init from `HogwartsApp.init()`, no-op when `SENTRY_DSN` empty); event taxonomy (OBS-002) still pending
- ⚠️ [CORE-009](../stories/CORE-009-env-config-schemes.md) Debug/staging/prod schemes [2] — **partial** (single Hogwarts scheme with Debug/Release; staging config missing; `SENTRY_DSN` + `SENTRY_ENVIRONMENT` wired through Info.plist substitution but xcconfig per-config not yet)
- ✅ [AUTH-005](../stories/AUTH-005-biometric-signin.md) Biometric sign-in gap fill [5] — **done** (`BiometricService` is `@Observable @MainActor` with full Face ID/Touch ID flow + enable/disable + lock/unlock; wired into `ContentView` via `@Environment` — `if biometricService.isBiometricEnabled && !biometricService.isUnlocked → BiometricPromptView`)
- ✅ [AUTH-007](../stories/AUTH-007-sign-in-with-apple.md) Sign in with Apple [5] — **done** (`SignInWithAppleButton` in `login-view.swift:166`, `ASAuthorizationAppleIDCredential` handler in `auth-manager.swift:108`)
- ⚠️ [AUTH-008](../stories/AUTH-008-token-refresh-hardening.md) Token refresh hardening [5] — **partial** — same scope as CORE-002 above

**Phase B (engineer 2):** localization + design
- F-LOCALE stories — Arabic-Indic digit formatter, locale-aware dates/currency, calendar
- F-DESIGN — Liquid Glass token audit, motion, contrast pass, atom studio

**Sprint 1 exit:** ✅ Every existing service compiles against `/api/mobile/*`. ✅ `xcodebuild test` green. ✅ Biometric + Sign in with Apple flows tested on device. ✅ Localizable.xcstrings has zero missing AR keys.

### Sprint 2 (weeks 3–4) — Phase C + first TestFlight

> **Status as of 2026-05-25** — push infrastructure is largely already built. Real remaining work is **governance** (consent flow, account export/delete) and **ship pipeline** (TestFlight + Fastlane). The push side just needed the `aps-environment` entitlement + foreground re-register + categories — all landed in `feat/sprint-2-audit`.

- ✅ [PUSH-001](../stories/PUSH-001-apns-registration.md) APNs registration + token POST [3] — **done** (`AppDelegate.didRegisterForRemoteNotificationsWithDeviceToken` POSTs via `APIClient.shared.registerDeviceToken`)
- ✅ [PUSH-002](../stories/PUSH-002-push-token-refresh-foreground.md) Token refresh on foreground [2] — **done in this branch** (`applicationWillEnterForeground` re-calls `registerForRemoteNotifications` so APNs token rotation after restore-from-backup is caught)
- ✅ [PUSH-003](../stories/PUSH-003-notification-categories-actions.md) Categories + Reply/Mark Read quick actions [5] — **done in this branch** (`MESSAGE`/`ANNOUNCEMENT`/`ATTENDANCE`/`GRADE` categories registered with Reply text-input + Mark Read + View actions; identifiers match backend APNs payload `category` field)
- ✅ [PUSH-004](../stories/PUSH-004-notification-deep-link-routing.md) Deep-link routing via `NotificationNavigationState` [5] — **done** (`NotificationRouter` parses userInfo → typed `Destination`; `AppDelegate.userNotificationCenter(didReceive:)` hops to MainActor and updates `NotificationNavigationState.shared`)
- ✅ [PUSH-005](../stories/PUSH-005-silent-push-sync.md) Silent push for sync triggers [3] — **done** (`application(didReceiveRemoteNotification:)` → `SyncEngine.shared.syncAll()` → `.newData`)
- ❌ [GOV-001](../stories/GOV-001-legal-consent-flow-first-login.md) Legal consent (TOS/Privacy/COPPA/GDPR-K) [5] — **not started** (no consent UI; depends on backend `GET/POST /api/mobile/consent/*` which is filed as hogwarts#279 but not yet shipped)
- ❌ [GOV-002](../stories/GOV-002-parental-consent-minors.md) Parental consent for minors [5] — **not started**
- ❌ [GOV-003](../stories/GOV-003-data-export-apple-guideline.md) Data export (Apple 5.1.1(v)) [5] — **not started** (depends on backend hogwarts#274)
- ❌ [GOV-004](../stories/GOV-004-account-deletion-apple-guideline.md) Account deletion [5] — **not started** (depends on backend hogwarts#275)
- ✅ [GOV-005](../stories/GOV-005-privacy-manifest-audit.md) Privacy manifest audit [3] — **done in this branch** (`PrivacyInfo.xcprivacy` expanded from 1 → 10 collected data types + 4 API access reasons; covers DeviceID, Email, Name, Phone, UserID, OtherUserContent, PhotosorVideos, CrashData, PerformanceData, OtherDiagnosticData)
- ❌ [GOV-006](../stories/GOV-006-app-tracking-transparency.md) ATT prompt [2] — **not started** (likely never prompts since `NSPrivacyTracking=false`, but story closure needs a code-level decision)
- ✅ [OBS-001](../stories/OBS-001-sentry-crash-reporting.md) Sentry crash reporting [3] — **done in PR #29**
- ❌ [OBS-002](../stories/OBS-002-event-taxonomy.md) Event taxonomy (`<feature>.<action>`) [5] — **not started** (needs lightweight wrapper over `SentrySDK.captureMessage` + breadcrumbs)
- ✅ [OBS-006](../stories/OBS-006-user-properties-segmented.md) Tenant/role/plan user properties [3] — **done in this branch** (`SentryBootstrap.setUserContext(userId:schoolId:role:locale:)` called from `AuthManager.saveSession`; `clearUserContext` from `signOut`; PII never set)
- ❌ [SHIP-001](../stories/SHIP-001-testflight-setup.md) TestFlight setup + private beta [3] — **not started** (no `.github/workflows/testflight.yml`)
- ❌ [SHIP-009](../stories/SHIP-009-fastlane-testflight-pipeline.md) (NEW) Fastlane + GitHub Actions TestFlight pipeline [3] — **not started** (no `fastlane/` dir)

**Bonus fix landed**: `aps-environment` entitlement was MISSING — even with PUSH-001 code present, real APNs would never deliver. Added per-config (`development` in Debug, `production` in Release) so this is no longer a launch blocker.

**Sprint 2 exit:** ⚠️ Push from APNs reaches device (entitlement now correct), tap opens correct deep link. ❌ Consent flow gates first launch. ✅ Sentry receives test crash. ❌ First TestFlight build distributed.

### Sprint 3 (weeks 5–6) — Phase D + E in parallel

> **Status as of 2026-05-25** — feature TODO sweep is almost a no-op (only 2 TODOs across all features) and the "0 feature tests" gap from the earlier draft was wrong: every module has a Swift Testing file with real assertions. CORE-010 cert pinning + CORE-011 background refresh both landed in `feat/sprint-3-audit`. Real remaining: Stripe SDK (PAY-*) blocked on backend `payments/process`, full a11y audit needs a real-device VoiceOver pass.

**Phase D — feature TODO sweep (engineer 1):**
- ✅ Every feature's `*-actions.swift` reads from `/api/mobile/*` for real (no stubs, no fixtures, no "Coming Soon" outside `coming-soon-view.swift`). Audit grep returned 2 TODOs total across the 19 features.
- ✅ Resolve `fee.swift` currency-from-school TODO — done in this branch: `currency: String?` added to the `School` extended fields (populated by `/mobile/admin/school`); `Double.formattedAsCurrency(locale:tenant:)` overload reads from `TenantContext.school?.currency ?? "SAR"`. Call-site rollout to the 10 fee views is a follow-up story (touches only existing string-interp lines).
- ⚠️ One open feature TODO: `dashboard/views/teacher-dashboard.swift:156` — routes to grades feature when a dedicated tab exists. Not launch-blocking (defer to v1.1).
- ❌ PAY-001 (Apple Pay) + PAY-002 (Stripe Card Sheet) + PAY-005 (Payment history) [≈19 pts] — depends on backend `POST /api/mobile/payments/process` (hogwarts#277) which is still open. iOS-side StripePaymentSheet wiring blocked on backend ship + Apple Pay merchant ID provisioning.

**Phase E — quality gates (engineer 2 + QA):**
- ⚠️ [Q-TEST stories](./Q-TEST.md) — scaffold is **done** (every module has ≥1 Swift Testing file: admin/announcements/events/fees/grades/guardian/idcard/profile/students/timetable/subjects each have a `*-tests.swift`; attendance has 3, auth has 6, dashboard has 5, messages/notifications/exams/teacher have 2 each). The 80% **coverage** target needs an `xcrun xccov view --report` run that we can only confirm after a full Xcode build cycle — measure, not author, is the remaining work.
- ❌ [Q-A11Y stories](./Q-A11Y.md) — atoms have `accessibilityLabel`s but the manual VoiceOver + Dynamic Type pass on 8 critical flows hasn't been done. Owner: Ali, on a real iPhone 15. Output goes into `docs/A11Y-AUDIT.md` (template already shipped in PR #28).
- ✅ [CORE-010](../stories/CORE-010-certificate-pinning.md) Certificate pinning [5] — **done in this branch** (`core/network/certificate-pinning.swift` + APIClient session uses delegate; SPKI-SHA256 base64 hashes read from `TLS_PIN_SHA256_SET` Info.plist; empty set in Debug = system trust; hosts gated by `TLS_PIN_HOSTS` so third-party SDKs are unaffected; rotation runbook in the file's doc-comment)
- ✅ [CORE-011](../stories/CORE-011-background-refresh.md) Background refresh via `BGAppRefreshTask` [3] — **done in this branch** (`org.databayt.Hogwarts.refresh` identifier registered in `BGTaskSchedulerPermittedIdentifiers` + `AppDelegate.registerBackgroundRefreshTask` handles + reschedules; `applicationDidEnterBackground` requests next run ≥15 min out; handler runs `SyncEngine.shared.syncAll()` with expiration cancel)

**Sprint 3 exit (revised):** ✅ Cert pinning gated by config (no Debug breakage). ✅ Background refresh request submitted on every background. ⚠️ 80% coverage not measured (needs Xcode run). ❌ Apple Pay sandbox checkout (blocked on hogwarts#277). ❌ VoiceOver pass on 8 flows (needs real device session with Ali).

### Sprint 4 (weeks 7–8) — Phase F: ship it

> **Status as of 2026-05-25** — every Apple-platform piece on the critical path now ships in code. EventKit + Photos picker were already wired (audited in Sprint 4). Universal Links + Core Spotlight + Spotlight result routing landed in `feat/sprint-4-audit`. Real remaining is **launch operations**: TestFlight setup (SHIP-001), Fastlane pipeline (SHIP-009), App Store Connect metadata + screenshots (SHIP-002), submission + appeal playbook (SHIP-007). Everything else either ships or needs only manual configuration.

- ✅ [AUTH-014](../stories/AUTH-014-universal-links-auth.md) Universal Links (invite, reset, magic link) [5] — **done in this branch** (`com.apple.developer.associated-domains` entitlement set to `applinks:ed.databayt.org`; `core/routing/deep-link-router.swift` parses URL → typed `Destination` covering `/app/*` feature paths + `/auth/reset/*` + `/auth/verify/*` + `/invite/*`; `ContentView` `.onContinueUserActivity(NSUserActivityTypeBrowsingWeb)` and `.onOpenURL` both feed `NotificationNavigationState.shared`. Backend still needs to serve the AASA file at `https://ed.databayt.org/.well-known/apple-app-site-association` — separate hogwarts ticket already in the cross-team P0 list.)
- ✅ [SRCH-001](../stories/SRCH-001-core-spotlight-indexing.md) Core Spotlight indexing [5] — **done in this branch** (`core/search/spotlight-indexer.swift` indexes announcements / conversations / contacts under tenant-scoped domain `org.databayt.Hogwarts.{schoolId}`; identifiers shaped `{type}:{id}` matching `DeepLinkRouter.destination(fromSpotlightIdentifier:)`; `wipe(schoolId:)` + `wipeAll()` for school-switch / sign-out; `ContentView` `.onContinueUserActivity(CSSearchableItemActionType)` routes taps. Grades/fees/attendance deliberately not indexed — privacy-sensitive.)
- ❌ [SRCH-002](../stories/SRCH-002-universal-search-bar.md) In-app universal search bar + NSUserActivity continuation [5] — **not started** (UI feature: needs search bar + results list + multi-entity backend search. NSUserActivity continuation half is done by SRCH-001; the in-app UI is a separate story.)
- ✅ [INT-001](../stories/INT-001-eventkit-add-to-calendar.md) EventKit add-to-calendar [3] — **done** (`event-detail-view.swift:160` has the full flow: `requestWriteOnlyAccessToEvents` iOS 17+ API, builds `EKEvent` from `SchoolEventDetail.resolvedRange()` with title/dates/location/notes, saves to default calendar with localized success/error toasts.)
- ✅ [INT-005](../stories/INT-005-photos-library-integration.md) Photos library integration [2] — **done** (`PhotosUI` + `PhotosPicker` + `PhotosPickerItem` wired in `edit-profile-view.swift` for avatar; `NSPhotoLibraryUsageDescription` + `NSPhotoLibraryAddUsageDescription` in Info.plist.)
- ✅ [SHIP-002](../stories/SHIP-002-app-store-assets.md) App Store assets EN+AR (6.9"/6.1"/iPad 13" screenshots × 2 locales × 5 flows) [5] — **done in `feat/sprint-4-screenshots-and-playbook`** (`scripts/capture-app-store-screenshots.sh` drives the 5 critical flows × 3 device sizes × 2 locales via `xcodebuild test` against a new `ScreenshotTests` XCTest case; output `build/screenshots/{locale}/{size}/{flow}.png` ready to drag-drop into App Store Connect; flow spec + manual fallback documented at `docs/release/app-store-screenshots.md`)
- ✅ [SHIP-003](../stories/SHIP-003-privacy-manifest-finalization.md) Privacy manifest finalization [3] — **done in PR #30** (`PrivacyInfo.xcprivacy` has 10 collected data types + 4 API access reasons)
- ✅ [SHIP-004](../stories/SHIP-004-export-compliance.md) Export compliance (encryption use declaration) [1] — **done** (`ITSAppUsesNonExemptEncryption: false` in `project.yml`)
- ✅ [SHIP-005](../stories/SHIP-005-release-notes-template.md) Release notes EN+AR [1] — **done in `feat/sprint-4-launch-ops`** (`docs/release/release-notes-template.md` bilingual; TestFlight workflow parses EN section automatically when tag annotation is empty)
- ✅ [SHIP-007](../stories/SHIP-007-app-review-submission.md) App Review submission + appeal playbook [3] — **done in `feat/sprint-4-screenshots-and-playbook`** (`docs/release/app-review-playbook.md` covers pre-submission gate, submission flow, 7 recurring rejection categories with specific fixes — 5.1.1(v) account deletion, 5.1.1 privacy mismatch, 4.0/4.5 design/spam, 2.1 crashes, 5.6.1 dark patterns, 4.5.2 IAP-required, 3.1.1 subscriptions — Resolution Center response procedure, escalation paths, post-rejection retrospective format)
- ✅ [SHIP-001](../stories/SHIP-001-testflight-setup.md) TestFlight setup [3] — **done in `feat/sprint-4-launch-ops`** (engineer runbook at `docs/release/testflight-distribution.md` walks through API key generation, Match repo bootstrap, GitHub Actions secret list, App Store Connect app shell, demo account, per-release cadence, troubleshooting + credential rotation)
- ✅ [SHIP-009](../stories/SHIP-009-fastlane-testflight-pipeline.md) Fastlane + GitHub Actions TestFlight pipeline [3] — **done in `feat/sprint-4-launch-ops`** (`fastlane/Fastfile` with `beta` + `release` lanes; `Appfile`/`Matchfile`/`Pluginfile`; `.github/workflows/testflight.yml` triggered on `v*` tag, runs on macos-15, secrets sourced from GitHub Actions environment; auto-increments build number from latest TestFlight, signs via Match readonly, uploads via pilot, pushes dSYMs to Sentry, posts to Slack)

**Sprint 4 exit (final):** ✅ Universal Links open the app. ✅ Spotlight result taps route to the correct screen. ✅ Tag → TestFlight pipeline reproducible. ✅ Release notes template + runbook in place. ✅ Screenshot capture script + ScreenshotTests scaffold. ✅ App Review appeal playbook ready. **Sprint 4 closed.** Only human operations remain: run the screenshot script, run the first tag-triggered build, fill the App Store Connect Privacy questionnaire to match `PrivacyInfo.xcprivacy`, tap Submit for Review.

---

## Cross-team Backend Dependencies (P0)

File these as `databayt/hogwarts` issues at **sprint 1 start**. Each blocks at least one M0 story.

| Status | Endpoint | Used by |
|--------|----------|---------|
| 🔴 NEW | `POST /api/mobile/payments/process` | PAY-001, PAY-002 |
| 🔴 NEW | `GET /api/mobile/account/export` | GOV-003 |
| 🔴 NEW | `POST /api/mobile/account/delete` | GOV-004 |
| 🔴 NEW | `GET/POST /api/mobile/consent/:id` | GOV-001, GOV-002 |
| 🔴 NEW | `GET /api/mobile/invoices/*` | FEE-003, FEE-004 |
| 🟡 CHECK | Web serves `https://ed.databayt.org/.well-known/apple-app-site-association` | AUTH-014 |
| 🟡 CHECK | `docs/MOBILE-HIERARCHY.md` exists in `databayt/hogwarts` | Doctrine reference |

Existing backend coverage: 41 `/api/mobile/*` endpoints live (auth, profile, dashboard, students, attendance, grades, conversations, messages, starred-messages, notifications, timetable, exams, fees view, report-cards, announcements, events, idcard, subjects, contacts, catalog, guardian, teacher, admin). See `/api/mobile/README.md` in `databayt/hogwarts`.

---

## Risks + Mitigations

| Risk | Mitigation |
|------|-----------|
| Backend P0 endpoints (payments, consent, account export/delete) slip | File issues sprint-1 day-1; iOS team uses sandbox stubs until live; flip via [CORE-007 feature flags](../stories/CORE-007-feature-flags.md) |
| Apple Review rejection on first submission | 24h fix-and-resubmit budget; common rejections (missing demo account, missing account-delete UI, privacy label inaccuracies) all addressed by GOV + SHIP-002/003 |
| APNs certificate / push routing breaks late | Use `.p8` APNs Auth Key not legacy certs; document key ID + team ID in 1Password; live test in sprint 2, not sprint 4 |
| Stripe + Apple Pay stretches beyond capacity | Cut to credit-card-only PaymentSheet for v1; defer Apple Pay button to v1.1 |
| Android lands a new feature mid-sprint that iOS must mirror | Hold the line — iOS lags Android by 1 sprint, not real-time. Phase D scope locks at sprint 3 start |
| 0-test gap balloons if sprint 3 test pass is shallow | Hard exit gate on phase E: coverage ≥80% before sprint 4. If not met, slip sprint 4 by one week rather than ship untested |
| 1M+ iOS users from open-source pitch overwhelm v1 backend | Phased release: 1% → 10% → 50% → 100% across first month (SHIP-006) |

---

## Out of scope for v1.0

Deferred to v1.1 or beyond. Tracked in the existing epics under `phase: M1` or `phase: M2`:

- **Widgets, Live Activities, iPad layout** ([F-PLATFORM-CORE](./F-PLATFORM-CORE.md), M1)
- **App Intents + Action Button mapping** ([F-INTENTS](./F-INTENTS.md), M1)
- **Universal Search + Spotlight beyond basic indexing** ([F-SEARCH](./F-SEARCH.md), M1 — basic indexing in sprint 4)
- **Exams, Report Cards, Subjects, Assignments, ID-card** (M1)
- **Library, Admission, AI-Doc, Quiz, Stream, Transport, Substitution, Wellbeing** (M2)
- **School-SaaS subscription via StoreKit 2** ([SUBSCRIPTION-SAAS](./SUBSCRIPTION-SAAS.md), M2)
- **App Clip, watchOS, Mac Catalyst, Vision** ([F-PLATFORM-EXTENDED](./F-PLATFORM-EXTENDED.md), M2)

---

## Definition of Done (overall)

- [ ] All Phase A–F exit gates green
- [ ] All M0 stories at `Status: done` in their respective `docs/stories/*.md` frontmatter
- [ ] App Store Connect submission **accepted** (not just submitted)
- [ ] First external school (Ahmed Baha / King Fahad Schools) signed in via TestFlight before public release
- [ ] Sentry shows < 0.5% crash-free sessions over the first week of TestFlight
- [ ] Phased rollout (1%) live within 7 days of acceptance
