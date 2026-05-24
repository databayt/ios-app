# OFF-002: PendingAction Queue v2 — Retry Policy

**Epic**: F-OFFLINE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user offline at write time
**I want** my action queued and retried when reconnecting
**So that** my work is never silently lost

## Acceptance Criteria

### AC-1: Persistent queue
**Given** an offline mutation **When** dispatched **Then** a `@Model PendingAction { id, schoolId, endpoint, method, body, attempts, nextAttemptAt, status }` row is inserted.

### AC-2: Exponential backoff
**Given** a retry **When** attempt N fails **Then** `nextAttemptAt = now + 2^N seconds`, capped at 5 minutes; max attempts 8 then status = `failed`.

### AC-3: Reconnect drains
**Given** the network returns **When** reachability fires **Then** queued actions for current `schoolId` drain in order; failures move to `failed`.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `errors`)
- [ ] schoolId predicate on every drain
- [ ] Audit logged (action attempt + result)

## Files
- `hogwarts/core/data/pending-action.swift` — `@Model`
- `hogwarts/core/sync/pending-action-runner.swift` — drain loop

## API Contract
- Consumes feature endpoints; not its own contract.

## i18n Keys
- `errors.offline.action_queued`, `errors.offline.action_failed_permanently`

## Tests
- `HogwartsTests/core/sync/pending-action-tests.swift` — backoff math, drain order, max attempts, tenant scope

## Dependencies
- Depends on: OFF-001, CORE-006
- Blocks: every mutating feature

## Definition of Done
- [ ] AC met, airplane-mode mutation → reconnect → applied verified, failed-state UX checked
