---
code: GOV
title: Governance & Compliance
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/consent/*", "/api/mobile/account/*"]
i18n_namespaces: [common, errors]
multi_tenant: required
---

# GOV — Governance & Compliance

## Goal
**App Store gate.** Without GOV, the app cannot ship. Implements legal consent flows (TOS, Privacy, COPPA, GDPR-K), parental consent for minors, data export, account deletion (Apple Guideline 5.1.1(v)), privacy manifest, App Tracking Transparency, audit log surfacing, terms re-acceptance.

## Scope

**In**: All compliance items required by App Store Review and applicable regulation. Critical-path M0.

**Out**: Subscription billing (SUBSCRIPTION-SAAS), wellbeing data privacy (WELLBEING).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| GOV-001 | Legal consent flow on first login (TOS, Privacy, COPPA, GDPR-K) | 5 | M0 | all |
| GOV-002 | Parental consent for minors | 5 | M0 | student, guardian |
| GOV-003 | Data export (Apple Guideline 5.1.1(v)) | 5 | M0 | all |
| GOV-004 | Account deletion (Apple Guideline 5.1.1(v)) | 5 | M0 | all |
| GOV-005 | Privacy manifest (PrivacyInfo.xcprivacy) audit + completion | 3 | M0 | all |
| GOV-006 | App Tracking Transparency (ATT) | 2 | M0 | all |
| GOV-007 | Audit log surfaced in settings (last logins, session activity) | 3 | M1 | all |
| GOV-008 | Terms updates re-acceptance | 3 | M1 | all |

## Cross-cutting checks
- [ ] All consent text fully localized in AR + EN
- [ ] Consent records tagged with `tenant_id`, `user_id`, `consent_version`, timestamp, device
- [ ] Account deletion requires re-auth + confirmation
- [ ] Data export emails user a download link within 24h
- [ ] ATT prompt only when actually tracking
- [ ] Privacy manifest declares all data collection accurately

## Backend dependencies
- 🔴 `GET /api/mobile/consent`, `POST /api/mobile/consent/:id` — file ticket
- 🔴 `POST /api/mobile/account/delete` — file ticket
- 🔴 `GET /api/mobile/account/export` — file ticket
- 🔴 Consent versioning model — file ticket

## Definition of Done
- [ ] First login → consent flow → cannot proceed without accepting
- [ ] Parental consent flow for under-13 students
- [ ] Settings → Delete Account → flow → confirmation email
- [ ] Settings → Export My Data → email with download link
- [ ] Privacy manifest accurate per actual data use
- [ ] App Store review accepts on first submission
