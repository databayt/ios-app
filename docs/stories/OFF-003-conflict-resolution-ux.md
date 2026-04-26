# OFF-003: Conflict Resolution UX — Server-Wins with Local Stash

**Epic**: F-OFFLINE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user whose offline edit conflicts with a server change
**I want** the server version to apply but my local changes preserved in a stash banner
**So that** I never silently lose my work

## Acceptance Criteria

### AC-1: 409 surfaces banner
**Given** a queued action returns 409 **When** the server-canonical entity is fetched **Then** the local edit is moved to a "stashed" model and a banner says "Your change conflicted; review and reapply".

### AC-2: Reapply or discard
**Given** the banner **When** the user taps Reapply **Then** the stash content prefills the editor; tapping Discard removes it.

### AC-3: Audit
**Given** a conflict **When** observed **Then** an `AuditLog` event records the conflict resolution choice.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `errors`, `common`)
- [ ] schoolId predicate (stash is tenant-scoped)
- [ ] RTL-tested
- [ ] Audit logged (conflict resolved)

## Files
- `hogwarts/core/sync/conflict-stash.swift` — `@Model StashedAction`
- `hogwarts/atoms/hw-conflict-banner.swift`
- `hogwarts/core/sync/pending-action-runner.swift` — extend to surface 409

## API Contract
- Consumes 409 responses with `If-Match` semantics from feature endpoints.

## i18n Keys
- `errors.conflict.title`, `errors.conflict.reapply`, `errors.conflict.discard`

## Tests
- `HogwartsTests/core/sync/conflict-tests.swift` — 409 fixture, stash creation, reapply path

## Dependencies
- Depends on: OFF-002
- Blocks: messaging, attendance, grading features

## Definition of Done
- [ ] AC met, snapshot AR + EN banner, reapply path verified, parity preserved
