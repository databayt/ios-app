# Product Requirements Document (PRD)
## Hogwarts iOS — v3.0

**Version**: 3.0
**Last Updated**: 2026-04-26
**Supersedes**: v2.0
**Status**: Approved

---

## 1. Executive Summary

### 1.1 Vision
Hogwarts iOS is the native mobile companion for the multi-tenant Hogwarts school management platform. It serves all 8 user roles (DEVELOPER, ADMIN, TEACHER, STUDENT, GUARDIAN, ACCOUNTANT, STAFF, USER) with offline-first capability, full Arabic-default RTL/i18n with on-demand content translation, strict multi-tenant isolation, and Apple-platform-native delights (Widgets, Live Activities, App Intents, VisionKit, Apple Watch).

### 1.2 Cross-Cutting Invariants (Non-Negotiable)

| Invariant | Doc | Enforcement |
|-----------|-----|-------------|
| **i18n & RTL** | `i18n.md` | `scripts/audit-i18n-hardcoded.sh`, `check-string-parity.sh`, pseudo-locale CI |
| **Multi-Tenancy** | `multitenancy.md` | `scripts/audit-tenant-scope.sh` |
| **All 8 Roles** | `roles.md` | Per-story frontmatter `roles:` declaration |
| **Content Translation** | `i18n.md` §"Content-Language Translation" | Per-entity `lang` field render + on-demand translate banner |
| **API Contract** | `.claude/rules/api-mobile.md` | All endpoints under `/api/mobile/*`, snake_case, JWT |

### 1.3 Goals
- **G1**: Mobile access to school information for all 8 user roles, with feature parity to kotlin-app v2
- **G2**: Offline-first; all reads work without network; writes queue and retry
- **G3**: Bilingual Arabic-default + English; full RTL; ≥99% string parity
- **G4**: Database content translation respecting entity `lang` field (announcements, messages, assignments)
- **G5**: Strict multi-tenant isolation — `schoolId` scoping on every query, audit log on every mutation
- **G6**: Apple-platform-native — Widgets, Live Activities, App Intents, VisionKit, eventually Watch
- **G7**: App Store compliance — privacy manifest, account deletion, parental consent, data export

### 1.4 Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| App Store Rating | 4.5+ | App Store Connect |
| Crash-Free Rate | 99.5%+ | Sentry / Xcode Organizer |
| Daily Active Users | 60% of web users | Analytics |
| Cold Launch Time | ≤ 1.5 s | XCTMetric, MetricKit |
| Frame Rate | 60 fps everywhere, 120 Hz on supported devices | Instruments |
| Memory | avg ≤150 MB, max ≤300 MB | Instruments |
| Battery | ≤ 3% per active hour | MetricKit |
| Offline Sessions | 30%+ | Custom analytics |
| Sync Success | 95%+ | Sync engine metrics |
| Test Coverage | 80%+ on services + viewmodels | Xcode coverage |
| AR/EN String Parity | ≥ 99% | `check-string-parity.sh` |
| Multi-Tenant Isolation | 100% (no leaks) | Integration tests |
| App Store Review | First-attempt accept | App Review Board |

---

## 2. User Personas (per Role)

### Pilot Roles (M0)
- **STUDENT** (6–18) — own timetable, attendance history, grades, assignments, fees, messages, ID, announcements
- **GUARDIAN** — multi-child selector, per-child views, excuse submit, fee pay, consent forms, meeting bookings
- **TEACHER** — classes, schedule, attendance marking (single/bulk/QR/NFC/kiosk), grading, lesson plans, messages, hall passes
- **ADMIN** — school dashboard, students CRUD, staff, classes, announcements authoring, KPIs, settings

### Near-Term Roles (M1)
- **ACCOUNTANT** — finance dashboard, fees, invoices, payments, refunds, scholarships, reports

### Later Roles (M2)
- **STAFF** — non-teaching staff schedule, payroll slip, leave, notices
- **USER** — pre-school applicant; multi-step admission flow; OTP status check

### Out of Scope
- **DEVELOPER** — platform admin (databayt staff). Web only. iOS detects + redirects.

For full role-feature matrix see `roles.md`.

---

## 3. Epic Taxonomy (48 epics)

Stories are kept in `docs/stories/<EPIC>-<NUM>-<slug>.md`. Each epic has its own page in `docs/epics/<EPIC>.md`. Plan-level breakdown:

### 3.1 Foundation Layer (12 epics)

| Code | Title | Phase |
|------|-------|-------|
| F-CORE | Core Infrastructure (APIClient, TenantContext, audit, telemetry) | M0 |
| F-DESIGN | Design System & Atoms (tokens, atoms, Liquid Glass, Dynamic Type) | M0 |
| F-LOCALE | i18n & RTL & Content Translation | M0 |
| F-OFFLINE | Offline-First Data Layer (SwiftData, sync engine v2) | M0 |
| F-PUSH | Push Notifications (APNs, deep-links, rich, silent, NSE) | M0 |
| F-MEDIA | Media & Files (pickers, cache, video, voice, PDF, upload manager) | M0/M1 |
| F-INTEGRATION | OS Integration (EventKit, Reminders, Photos, Files, Contacts) | M0/M1 |
| F-SHARING | Share Sheet, AirDrop, Handoff | M0/M1 |
| F-SEARCH | Spotlight + universal search | M1 |
| F-INTENTS | App Intents, Siri, Shortcuts, Focus Filter, Action Button | M0/M1 |
| F-PLATFORM-CORE | Widgets, Live Activities, iPad split | M1 |
| F-PLATFORM-EXTENDED | Watch, Catalyst, visionOS | M2 |

### 3.2 Identity & Onboarding (4 epics)

| Code | Title | Phase |
|------|-------|-------|
| AUTH | Authentication (extends existing AUTH-001..006) | M0 |
| ONBOARD | First-Run Experience | M0 |
| PROFILE | User Profile | M0 |
| SETTINGS | App Settings (incl. App-Store-blocking export + delete) | M0 |

### 3.3 Role Surfaces (2 epics)

| Code | Title | Phase |
|------|-------|-------|
| HOME | Springboard Home (extends existing) | M0 |
| DASHBOARD | Role-aware Dashboard (one epic, 6 role-tracks) | M0 |

### 3.4 Modules (24 epics)

| Code | Title | Phase |
|------|-------|-------|
| TIMETABLE | Schedule & Calendar | M0 |
| ATTENDANCE | Student history + Teacher mark (QR/NFC/kiosk/beacon) | M0/M1 |
| GRADES | Grades & GPA | M0/M1 |
| REPORTCARD | Report Cards | M1 |
| EXAMS | Exams & Quizzes (online taking, lockdown) | M1 |
| ASSIGNMENTS | Assignments & Submissions | M1 |
| MESSAGING | WhatsApp-style chat (real-time, offline queue) | M0 |
| ANNOUNCE | Announcements (read + author, content lang picker) | M0 |
| NOTIF | Notifications (in-app, prefs, quiet hours) | M0 |
| FEES | Fees + Payments (Apple Pay, Stripe, cash, bank) | M0/M1 |
| EVENTS | School Events | M1 |
| LIBRARY | Library Catalog | M2 |
| SUBJECTS | Subjects Catalog | M1 |
| STREAM | LMS Course Stream | M2 |
| QUIZ | Quiz Game | M2 |
| IDCARD | Digital ID + Wallet pass | M1/M2 |
| GUARDIAN-LINK | Multi-child linkage + selector + consent + meetings | M0/M2 |
| SUBSTITUTION | Teacher absence + cover workflow | M2 |
| WELLBEING | Health, Discipline, Achievements, Counselor | M2 |
| AI-DOC | AI Document Processing (VisionKit + backend job) | M2 |
| SUBSCRIPTION-SAAS | School-level Hogwarts SaaS billing (StoreKit 2) | M2 |
| ADMISSION | Public applicant flow | M2 |
| TRANSPORT | Bus & Live Tracking | M2 |
| GOV | **App Store Blocker** — Consent, Export, Deletion, ATT, Privacy Manifest | M0 |

### 3.5 Quality & Ship (6 epics)

| Code | Title | Phase |
|------|-------|-------|
| Q-TEST | Test Infrastructure (Swift Testing + XCTest + snapshots + E2E) | M0/M1 |
| Q-A11Y | Accessibility (VoiceOver, Dynamic Type, Reduce Motion) | M0 |
| Q-PERF | Performance (launch, fps, memory, battery) | M1 |
| Q-SECURITY | Security (cert pinning, OWASP MASVS L1) | M1 |
| OBS | Observability (Sentry, MetricKit, in-app feedback) | M0/M1 |
| SHIP | Release & TestFlight | M0/M1 |

---

## 4. Phasing

### M0 — Pilot Bring-up (10–14 weeks): Student + Guardian + Teacher read-only
**Goal**: TestFlight private beta with student/guardian/teacher seeing real data from demo school in both AR and EN, with full RTL, push notifications, offline reads, governance/consent flows.

In-scope: F-CORE, F-DESIGN, F-LOCALE (1-9, 11), F-OFFLINE, F-PUSH (1-5), F-MEDIA (1, 7), F-INTEGRATION (1, 5), F-SHARING (1), AUTH (extend), ONBOARD, PROFILE, SETTINGS, HOME, DASHBOARD (S/G/T tracks), TIMETABLE (1-4, 6), ATTENDANCE (student-side 1-2 only), GRADES (1-3, 5), MESSAGING (text + read receipt + archive + mute + offline + socket), ANNOUNCE (reader), NOTIF (1-5), FEES (view-only), GUARDIAN-LINK (1-3), GOV (all M0), Q-A11Y (1-7), Q-TEST (M0), OBS (1-2, 6), SHIP (1-5, 7).

### M1 — Pilot Pro (8–12 weeks): Teacher MVP + Payments + Widgets
Adds teacher mark-attendance, grade entry, fees+payments via Apple Pay, widgets + live activities, exams + assignments + report cards, search, intents.

### M2 — Expansion + Watch (12–16 weeks)
Adds LIB, SUB, STREAM, QUIZ, IDCARD wallet, ADMISSION, TRANSPORT, AI-DOC, WELLBEING, SUBSTITUTION, SUBSCRIPTION-SAAS, Watch + Catalyst, full Q-* sweep.

---

## 5. Backend Coordination

Mobile depends on `/api/mobile/*` endpoints from `databayt/hogwarts`. Gaps tracked in `docs/backend-gaps.md`. P0 gaps blocking M1:
- `POST /api/mobile/translate` (NEW) — content translation cache
- `POST /api/mobile/account/delete`, `GET /api/mobile/account/export` — App Store
- `GET/POST /api/mobile/consent/*` — legal consent
- `GET /api/mobile/invoices/*`, `POST /api/mobile/payments/*` — fees+payments

P1 gaps blocking M1 expansion: report cards PDF, teacher mutations (grade entry, attendance mark), online exam answers/results, admin staff/classes endpoints, guardian excuse/intention/consent endpoints, search endpoint.

P2 gaps blocking M2: library, subjects/lessons, stream LMS, quiz, ID card wallet pass, transport, AI-DOC jobs, subscription, substitution, wellbeing, admission applicant.

---

## 6. RBAC Matrix

See `docs/roles.md` for the full feature × role matrix. Summary:

| Cluster | DEV | ADM | TCH | STU | GRD | ACC | STF | USR |
|---------|-----|-----|-----|-----|-----|-----|-----|-----|
| Auth + Profile + Settings | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Messaging + Announcements + Notifications | — | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| Timetable + Subjects | — | ✓ | ✓ | ✓ | ✓(child) | — | ✓ | — |
| Attendance (own/child) | — | — | — | ✓ | ✓ | — | — | — |
| Attendance (mark) | — | ✓ | ✓ | — | — | — | — | — |
| Grades + Report Cards (own/child) | — | ✓ | ✓ | ✓ | ✓(child) | — | — | — |
| Grade entry | — | — | ✓ | — | — | — | — | — |
| Exams + Assignments (own) | — | — | — | ✓ | — | — | — | — |
| Exams + Assignments (author/grade) | — | — | ✓ | — | — | — | — | — |
| Fees (view) | — | ✓ | — | ✓ | ✓(child) | ✓ | — | — |
| Fees (pay) | — | — | — | — | ✓ | — | — | — |
| Fees (record cash + refund) | — | ✓ | — | — | — | ✓ | — | — |
| Events RSVP | — | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| ID card | — | ✓ | ✓ | ✓ | — | ✓ | ✓ | — |
| Children list + multi-child | — | — | — | — | ✓ | — | — | — |
| Admin functions | — | ✓ | — | — | — | — | — | — |
| Admission apply | — | — | — | — | — | — | — | ✓ |

---

## 7. Definition of Done (Release Level)

Before TestFlight public:
- [ ] All M0 stories merged
- [ ] All M0 epics' DoD checklists green
- [ ] App Store Review accepted on first attempt
- [ ] All 8 roles login successfully (3 — DEV, STAFF, USER — may show role-mismatch redirect; that's accepted)
- [ ] Arabic + English fully parity-checked
- [ ] Multi-tenant isolation tests green
- [ ] Privacy manifest accurate per actual data use
- [ ] Account deletion + data export flows tested
- [ ] Push notifications working on real device (APNs production)
- [ ] Sentry receiving production events
- [ ] CI green: lint + typecheck + tests + i18n + tenant gates

---

## 8. Reference

- Architecture: `docs/architecture.md`
- Cross-cutting playbooks: `docs/i18n.md`, `multitenancy.md`, `roles.md`
- Backend gaps: `docs/backend-gaps.md`
- Story template: `docs/STORY-TEMPLATE.md`
- BMAD workflow: `docs/bmad-workflow-status.yaml`
- Design system: `docs/apple-design-guidelines.md`
- TestFlight: `docs/testflight-distribution.md`
- Web mobile API: `/Users/abdout/hogwarts/src/app/api/mobile/README.md`
- Android reference: `/Users/abdout/kotlin-app/`
