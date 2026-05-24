# CORE-008: Telemetry Sink (Sentry + custom events)

**Epic**: F-CORE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** developer triaging issues
**I want** every error and key event flowing into Sentry tagged with `tenant_id` and `role`
**So that** I can filter incidents by school and role without exporting logs

## Acceptance Criteria

### AC-1: Sentry SDK wired
**Given** the app boots **When** SentrySDK initializes **Then** DSN comes from env (CORE-009) and breadcrumbs include the current `app_locale`.

### AC-2: Tenant tags on every event
**Given** TenantContext has a value **When** an error or event is captured **Then** the Sentry scope contains `tenant_id`, `role`, `app_locale`.

### AC-3: Custom events
**Given** code calls `Telemetry.log(.attendanceMarked(count: 30))` **When** observed **Then** the event is recorded with structured payload, never PII.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `errors`) — error UI only
- [ ] schoolId predicate (tag value)
- [ ] No PII in payloads

## Files
- `hogwarts/core/telemetry/telemetry.swift` — `Telemetry` facade + Sentry adapter
- `hogwarts/core/telemetry/event.swift` — typed event enum

## API Contract
- Sentry SaaS endpoint (configured by DSN).

## i18n Keys
- None (Sentry receives English event names by convention; user-visible errors use `errors.*`)

## Tests
- `HogwartsTests/core/telemetry/telemetry-tests.swift` — scope tags, event encoding

## Dependencies
- Depends on: CORE-005, CORE-009
- Blocks: incident response

## Definition of Done
- [ ] AC met, staging events visible in Sentry within 1 min, no PII detected
