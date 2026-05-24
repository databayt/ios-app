# SET-008: Privacy — Delete Account

**Epic**: SETTINGS
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want to delete my account with a clear confirmation, so that I have control over my data per Apple Guideline 5.1.1(v).

## Acceptance Criteria
### AC-1: Confirm + soft delete
**Given** I tap "Delete account" **When** I type my email and confirm **Then** the account enters 30-day soft-delete; I am signed out; an email confirmation is sent.

### AC-2: Cancellation window
**Given** I sign in within 30 days **When** auth resolves **Then** I see "Reactivate account" option; tapping it cancels deletion.

### AC-3: Cross-cutting
No dark patterns — destructive button colored red, primary action labeled clearly. Audit log. Tenant data not auto-deleted (admin owns school data).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `auth`, `common`)
- [ ] RTL-tested (red destructive button position)
- [ ] schoolId predicate (own user across all schools)
- [ ] Role-gated (own user; admin must transfer ownership first)
- [ ] Audit logged

## Files
- `hogwarts/features/settings/views/delete-account-view.swift`
- `hogwarts/features/settings/viewmodels/delete-account-viewmodel.swift`
- `hogwarts/features/settings/services/account-service.swift`

## API Contract
- `POST /api/mobile/account/delete` — body `{ confirmEmail }` → `{ scheduledDeletionAt }`
- `POST /api/mobile/account/reactivate`

## i18n Keys
- `profile.delete.title`, `profile.delete.warning`, `profile.delete.confirm_email`, `profile.delete.scheduled`, `profile.delete.reactivate`

## Tests
- `HogwartsTests/settings/delete-account-tests.swift`
- Snapshot AR + EN + light/dark; admin-blocking test

## Dependencies
- Depends on: SET-001, AUTH-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved, App Review compliant
