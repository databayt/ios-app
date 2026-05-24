---
code: SETTINGS
title: App Settings
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/account/export", "/api/mobile/account/delete"]
i18n_namespaces: [profile, notifications, common]
multi_tenant: required
---

# SETTINGS — App Settings

## Goal
App-level settings (distinct from PROFILE): notifications per channel, language override, theme, accessibility, data usage, privacy & data (export, delete), diagnostics. App-Store-blocking: account deletion + data export.

## Scope

**In**: Settings root (grouped list), notifications per channel + quiet hours, language override, theme, accessibility (Dynamic Type, Reduce Motion, High Contrast), data usage (cellular vs wifi, image quality), privacy export, account deletion, diagnostics (logs, support bundle).

**Out**: Profile edit (PROFILE), security (AUTH).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| SET-001 | Settings root (grouped list, iOS-style) | 2 | M0 | all |
| SET-002 | Notifications settings (per channel, quiet hours) | 5 | M0 | all |
| SET-003 | Language override (per-app, decoupled from system) | 2 | M0 | all |
| SET-004 | Theme (light/dark/system) | 1 | M0 | all |
| SET-005 | Accessibility (dynamic type, reduce motion, high contrast) | 3 | M0 | all |
| SET-006 | Data usage (cellular vs wifi, image quality, video preload) | 3 | M1 | all |
| SET-007 | Privacy & data — export my data | 5 | M0 | all |
| SET-008 | Privacy & data — delete account | 5 | M0 | all |
| SET-009 | Diagnostics (logs, ping, support bundle) | 3 | M1 | all |

## Cross-cutting checks
- [ ] All strings localized
- [ ] Language toggle effective without restart
- [ ] Account deletion flow per Apple Guideline 5.1.1(v): visible, easy, no dark patterns
- [ ] Data export emails user a download link (async job)
- [ ] Diagnostics bundle excludes PII

## Backend dependencies
- 🔴 `POST /api/mobile/account/delete` — App Store blocker
- 🔴 `GET /api/mobile/account/export` — App Store blocker (NEW)
- 🟡 Notification preferences — already via NOTIF epic

## Definition of Done
- [ ] Account deletion: flow → confirm → 30-day soft delete → email confirmation
- [ ] Data export: tap → email → JSON archive within 24h
- [ ] App Review accepts privacy manifest + deletion path
