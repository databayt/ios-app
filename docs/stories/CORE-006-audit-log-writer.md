# CORE-006: AuditLog Client Writer

**Epic**: F-CORE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** compliance-minded org
**I want** every iOS-originated mutation to write a backend AuditLog entry
**So that** we have a complete trail of who changed what across web + mobile

## Acceptance Criteria

### AC-1: Mutations log
**Given** any feature performs a mutation (attendance mark, fee pay, message send) **When** the action succeeds **Then** `AuditLog.write(action:, entityId:)` posts `{ tenant_id, user_id, action, entity_id, timestamp }` to the backend.

### AC-2: Offline queue
**Given** offline at write time **When** the audit event is created **Then** it queues in PendingAction and flushes on reconnect.

### AC-3: Read-only actions skipped
**Given** a GET request **When** completed **Then** no audit entry is created.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `errors`)
- [ ] schoolId predicate (always `TenantContext.currentSchoolId`)
- [ ] Audit logged (this IS the audit logger)

## Files
- `hogwarts/core/audit/audit-log.swift` — `AuditEvent` + sender
- `hogwarts/core/audit/audit-action.swift` — typed action enum

## API Contract
- `POST /api/mobile/audit` (verify exists; file ticket if not) — request `{ action, entity_id?, metadata? }`; tenant + user inferred from JWT

## i18n Keys
- `errors.audit.queue_full`

## Tests
- `HogwartsTests/core/audit/audit-log-tests.swift` — write, queue offline, flush online

## Dependencies
- Depends on: CORE-001, CORE-005
- Blocks: every mutating feature

## Definition of Done
- [ ] AC met, tests pass, backend AuditLog rows visible from staging build
