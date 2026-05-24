---
code: ONBOARD
title: First-Run Experience
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: []
i18n_namespaces: [onboarding, common]
multi_tenant: required
---

# ONBOARD — First-Run Experience

## Goal
A respectful, role-aware onboarding that primes permissions just-in-time, lets users join a school via code, and offers demo mode for evaluation — all in either Arabic or English with first-launch locale picker.

## Scope

**In**: Hero/welcome carousel (3 screens), permission priming (notifications, photos, calendar, biometric) with rationale, role-aware tour, school join code entry, demo mode entry, locale picker on first launch, re-onboarding after major update.

**Out**: Login UX (AUTH), profile completion (PROFILE).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| ONBOARD-001 | Hero/welcome carousel (3 screens, localized, RTL-aware) | 3 | M0 | all |
| ONBOARD-002 | Permission priming (notifications, photos, calendar, biometric) with rationale | 5 | M0 | all |
| ONBOARD-003 | Role-aware tour (4 personas) | 5 | M0 | all |
| ONBOARD-004 | School join code entry | 3 | M0 | all |
| ONBOARD-005 | Demo mode entry from welcome | 2 | M0 | all |
| ONBOARD-006 | Locale picker on first launch | 2 | M0 | all |
| ONBOARD-007 | Re-onboarding after major update | 2 | M1 | all |

## Cross-cutting checks
- [ ] All onboarding strings localized (onboarding namespace)
- [ ] First launch defaults to Arabic; user can pick English
- [ ] Hero carousel reverses scroll direction in RTL
- [ ] Permission rationale matches `Info.plist` usage descriptions
- [ ] Tour adapts to detected role after login

## Backend dependencies
- ✅ `/api/mobile/schools` — list join codes available

## Definition of Done
- [ ] First launch: locale picker → onboarding → permissions → login → tour → home
- [ ] Demo mode skips real auth, lands on sample data
- [ ] Tour visible only on first launch + after major version
