---
code: AUTH
title: Authentication & Account Management
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/auth/*"]
i18n_namespaces: [auth, errors]
multi_tenant: required
---

# AUTH — Authentication & Account

## Goal
Bullet-proof authentication: email/password, OAuth (Google, Apple, Facebook), biometric, OTP, race-safe token refresh, multi-school join, must-change-password flow, 2FA, universal-link auth deep-links, demo mode. AUTH-001..006 already merged; this epic completes the gap (005) and extends through 015.

## Scope

**In**: AUTH-005 biometric sign-in (gap fill), AUTH-007+ extensions including Sign in with Apple, hardened refresh, multi-school join, logout-all-devices, password change, 2FA, session restore, universal links, SSO invitation, lockout protection, demo mode.

**Out**: First-run UX (ONBOARD), profile edit (PROFILE), settings (SETTINGS).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| AUTH-001 | Google OAuth sign-in | — | done | all |
| AUTH-002 | Facebook OAuth sign-in | — | done | all |
| AUTH-003 | Email/Password sign-in | — | done | all |
| AUTH-004 | School selection (multi-tenant picker) | — | done | all |
| AUTH-005 | Biometric sign-in (Face ID / Touch ID) — gap fill | 5 | M0 | all |
| AUTH-006 | Session management (JWT, refresh, restore) | — | done | all |
| AUTH-007 | Sign in with Apple (replace stubbed Apple) | 5 | M0 | all |
| AUTH-008 | Token refresh hardening (race-safe) | 5 | M0 | all |
| AUTH-009 | Multi-school join code flow | 5 | M0 | all |
| AUTH-010 | Logout on all devices | 3 | M0 | all |
| AUTH-011 | Password change (must-change-password flow) | 3 | M0 | all |
| AUTH-012 | 2FA setup (TOTP + backup codes) | 8 | M1 | all |
| AUTH-013 | Session restore polish + offline grace period | 3 | M0 | all |
| AUTH-014 | Universal Links auth deep-link (invite, reset) | 5 | M0 | all |
| AUTH-015 | SSO invitation accept (school invites email) | 5 | M1 | all |
| AUTH-016 | Account lockout + bot protection UI | 3 | M1 | all |
| AUTH-017 | Demo mode (read-only sandbox tenant) | 3 | M0 | all |

## Cross-cutting checks
- [ ] All auth strings localized (auth namespace)
- [ ] RTL layout for login/signup forms
- [ ] Biometric prompt localized
- [ ] Tokens stored in Keychain (never UserDefaults)
- [ ] On login, TenantContext populated from JWT before any feature load
- [ ] Apple sign-in respects Apple's "Hide My Email"

## Backend dependencies
- ✅ `/api/mobile/auth/*` — live (sign-in, sign-up, reset, OAuth, refresh, logout, OTP)
- 🟡 `/api/mobile/auth/2fa/*` — verify or file ticket
- 🔴 `/api/mobile/auth/lockout` — rate limit signal
- 🔴 `/api/mobile/account/delete` — see GOV epic

## Definition of Done
- [ ] All 12 in-scope stories merged
- [ ] Sign-in succeeds for all 4 providers + email/password
- [ ] Token refresh under load (10 concurrent requests) → no double-refresh
- [ ] Multi-school user can switch via Profile → School
- [ ] Demo mode loads sandbox data
