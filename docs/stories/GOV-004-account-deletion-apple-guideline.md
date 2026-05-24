# GOV-004: Account Deletion

**Epic**: GOV — APP STORE BLOCKER
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to delete my account from inside the app
**So that** I exercise my right to erasure

## Acceptance Criteria

### AC-1: In-app deletion (App Store guideline 5.1.1(v))
**Given** the user is in Settings → Privacy
**When** they tap "Delete Account"
**Then** deletion flow runs entirely in-app — required for Apple Guideline 5.1.1(v) (account deletion must be in-app for any account-creating app)

### AC-2: Re-auth + confirmation
**Given** user starts deletion
**When** they confirm
**Then** re-authentication is required and a localized double-confirmation dialog gates the action

### AC-3: Server-side cascade + email
**Given** confirmed
**When** server processes
**Then** account marked for deletion, all PII cascaded per retention policy, confirmation email sent

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId scoped deletion
- [ ] Role gate: all (self-deletion only)
- [ ] Audit log
- [ ] App Store BLOCKER (5.1.1(v))

## Files
- `hogwarts/features/gov/views/account-deletion-view.swift`
- `hogwarts/features/gov/viewmodels/account-deletion-viewmodel.swift`
- `hogwarts/features/gov/services/account-service.swift`

## API Contract
- `POST /api/mobile/account/delete` — `{ password_or_token }` → `{ scheduled_at }`

## i18n Keys
- `common.privacy.delete_account`, `confirm_delete`, `re_auth_required`, `delete_email_sent`

## Tests
- `HogwartsTests/gov/account-deletion-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: SHIP-007 (App Review)

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, Apple Guideline 5.1.1(v) satisfied, audit logged
