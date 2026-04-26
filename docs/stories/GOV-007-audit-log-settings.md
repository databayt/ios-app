# GOV-007: Audit Log Surfaced in Settings

**Epic**: GOV
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to see my recent logins and session activity
**So that** I can detect unauthorized access

## Acceptance Criteria

### AC-1: Render activity list
**Given** user opens Settings → Security → Activity
**When** screen loads
**Then** last 30 logins render with date, device, location-approx, role

### AC-2: Sign out other sessions
**Given** an active session looks suspicious
**When** user taps "Sign out other devices"
**Then** all sessions except current are revoked server-side

### AC-3: Empty / single-session state
**Given** only the current session exists
**When** screen loads
**Then** localized empty-state message

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: self only
- [ ] Audit log entry on revoke

## Files
- `hogwarts/features/gov/views/audit-log-view.swift`
- `hogwarts/features/gov/viewmodels/audit-log-viewmodel.swift`
- `hogwarts/features/gov/services/audit-service.swift`

## API Contract
- `GET /api/mobile/account/sessions` → `{ sessions: [] }`
- `POST /api/mobile/account/sessions/revoke-others`

## i18n Keys
- `common.security.activity_title`, `signed_in_at`, `revoke_others`, `empty`

## Tests
- `HogwartsTests/gov/audit-log-tests.swift`

## Dependencies
- Depends on: AUTH-006, CORE-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit logged
