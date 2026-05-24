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

### Sprint 1 (weeks 1–2) — Phase A + B

**Phase A (engineer 1):** the backbone
- [CORE-001](../stories/CORE-001-api-client-mobile-prefix.md) APIClient `/api/mobile/*` + snake_case [3 pts] — **#1 blocker, do first**
- [CORE-002](../stories/CORE-002-token-refresh-race-safe.md) Token refresh via `PUT /mobile/auth` [5]
- [CORE-003](../stories/CORE-003-remove-mock-login-bypass.md) Remove mock login bypass [1]
- [CORE-004](../stories/CORE-004-jwt-decode-helper.md) JWT decode helper [2]
- [CORE-005](../stories/CORE-005-tenant-context-observable.md) `TenantContext` observable [3]
- [CORE-006](../stories/CORE-006-audit-log-writer.md) Audit log writer [3]
- [CORE-008](../stories/CORE-008-telemetry-sink.md) Sentry SDK + custom event sink [3]
- [CORE-009](../stories/CORE-009-env-config-schemes.md) Debug/staging/prod schemes [2]
- [AUTH-005](../stories/AUTH-005-biometric-sign-in.md) Biometric sign-in gap fill [5]
- [AUTH-007](../stories/AUTH-007-sign-in-with-apple.md) Sign in with Apple [5]
- [AUTH-008](../stories/AUTH-008-token-refresh-hardening.md) Token refresh hardening [5]

**Phase B (engineer 2):** localization + design
- F-LOCALE stories — Arabic-Indic digit formatter, locale-aware dates/currency, calendar
- F-DESIGN — Liquid Glass token audit, motion, contrast pass, atom studio

**Sprint 1 exit:** ✅ Every existing service compiles against `/api/mobile/*`. ✅ `xcodebuild test` green. ✅ Biometric + Sign in with Apple flows tested on device. ✅ Localizable.xcstrings has zero missing AR keys.

### Sprint 2 (weeks 3–4) — Phase C + first TestFlight

- [PUSH-001](../stories/PUSH-001-apns-registration.md) APNs registration + token POST [3]
- [PUSH-002](../stories/PUSH-002-token-refresh-foreground.md) Token refresh on foreground [2]
- [PUSH-003](../stories/PUSH-003-notification-categories.md) Categories + Reply/Mark Read quick actions [5]
- [PUSH-004](../stories/PUSH-004-deep-link-routing.md) Deep-link routing via `NotificationNavigationState` [5]
- [PUSH-005](../stories/PUSH-005-silent-push-sync.md) Silent push for sync triggers [3]
- [GOV-001](../stories/GOV-001-legal-consent-flow-first-login.md) Legal consent (TOS/Privacy/COPPA/GDPR-K) [5]
- [GOV-002](../stories/GOV-002-parental-consent-minors.md) Parental consent for minors [5]
- [GOV-003](../stories/GOV-003-data-export-apple-guideline.md) Data export (Apple 5.1.1(v)) [5]
- [GOV-004](../stories/GOV-004-account-deletion-apple-guideline.md) Account deletion [5]
- [GOV-005](../stories/GOV-005-privacy-manifest-audit.md) Privacy manifest audit [3]
- [GOV-006](../stories/GOV-006-app-tracking-transparency.md) ATT prompt [2]
- [OBS-001](../stories/OBS-001-sentry-crash-reporting.md) Sentry crash reporting [3]
- [OBS-002](../stories/OBS-002-event-taxonomy.md) Event taxonomy (`<feature>.<action>`) [5]
- [OBS-006](../stories/OBS-006-user-properties-segmented.md) Tenant/role/plan user properties [3]
- [SHIP-001](../stories/SHIP-001-testflight-setup.md) TestFlight setup + private beta [3]
- **[SHIP-009](../stories/SHIP-009-fastlane-testflight-pipeline.md) (NEW)** Fastlane + GitHub Actions TestFlight pipeline [3]

**Sprint 2 exit:** ✅ Push from APNs reaches device, tap opens correct deep link. ✅ Consent flow gates first launch. ✅ Sentry receives test crash. ✅ First TestFlight build distributed to Ali + Ahmed Baha (King Fahad Schools pilot).

### Sprint 3 (weeks 5–6) — Phase D + E in parallel

**Phase D — feature TODO sweep (engineer 1):**
- Every feature's `*-actions.swift` reads from `/api/mobile/*` for real (no stubs, no fixtures, no "Coming Soon" except `coming-soon-view.swift`)
- Resolve `fees-actions.swift` currency-from-school TODO via `/admin/school`
- PAY-001 (Apple Pay) + PAY-002 (Stripe Card Sheet) + PAY-005 (Payment history) [≈19 pts] — depends on backend `POST /api/mobile/payments/process`

**Phase E — quality gates (engineer 2 + QA):**
- Q-TEST stories — fill the **0-feature-test gap**: every `*-view-model.swift` gets a `HogwartsTests/{feature}/{feature}-view-model-tests.swift` using Swift Testing. Existing scaffolds cover the new modules; add for `grades`, `students`, `timetable`, `profile`, `reportcards`.
- [Q-A11Y stories](./Q-A11Y.md) — VoiceOver + Dynamic Type pass on 8 critical flows (login, dashboard, attendance-mark, grade-view, message-send, fee-pay, notification-tap, profile-edit) → results in `docs/A11Y-AUDIT.md`
- [CORE-010](../stories/CORE-010-certificate-pinning.md) Certificate pinning [5]
- [CORE-011](../stories/CORE-011-background-refresh.md) Background refresh via `BGAppRefreshTask` [3]

**Sprint 3 exit:** ✅ `xcrun xccov view --report` shows ≥80% on `core/` + every ViewModel. ✅ Manual smoke-test of every feature in TestFlight against demo accounts (admin/teacher/student/parent). ✅ Apple Pay sandbox checkout succeeds end-to-end. ✅ VoiceOver clean on 8 flows.

### Sprint 4 (weeks 7–8) — Phase F: ship it

- [AUTH-014](../stories/AUTH-014-universal-links-deep-link.md) Universal Links (invite, reset, magic link) [5]
- SRCH-001 Core Spotlight indexing [5]
- SRCH-002 In-app universal search bar + NSUserActivity continuation [5]
- INT-001 EventKit add-to-calendar [3]
- INT-005 Photos library integration [2]
- [SHIP-002](../stories/SHIP-002-app-store-assets.md) App Store assets EN+AR (6.7"/6.1"/iPad screenshots × 2 locales) [5]
- [SHIP-003](../stories/SHIP-003-privacy-manifest-finalization.md) Privacy manifest finalization [3]
- [SHIP-004](../stories/SHIP-004-export-compliance.md) Export compliance (encryption use declaration) [1]
- [SHIP-005](../stories/SHIP-005-release-notes-template.md) Release notes EN+AR [1]
- SHIP-007 App Review submission + appeal playbook [3]

**Sprint 4 exit:** ✅ Tag `v1.0.0-rc1` on `main` → Fastlane builds & uploads to App Store Connect within 30 min. ✅ Privacy nutrition label complete, demo account `apple-review@databayt.org` works. ✅ Submission accepted (or feedback fixed-and-resubmitted within 24h).

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
