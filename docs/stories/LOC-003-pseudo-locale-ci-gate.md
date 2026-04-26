# LOC-003: Pseudo-Locale CI Gate (en-XA, ar-XB)

**Epic**: F-LOCALE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** translation auditor
**I want** pseudo-locales `en-XA` and `ar-XB` rendered automatically in CI snapshots
**So that** any hardcoded English or LTR-only assumption surfaces visually before merge

## Acceptance Criteria

### AC-1: Pseudo-locales generated
**Given** the build **When** `scripts/generate-pseudo-locales.sh` runs **Then** `en-XA` (Latin-pseudo with accents and length expansion) and `ar-XB` (RTL-pseudo) lprojs are produced.

### AC-2: Snapshot at pseudo
**Given** snapshot tests **When** the suite runs **Then** every screen has an `en-XA` and `ar-XB` snapshot stored under `tests/snapshots/pseudo/`.

### AC-3: Hardcoded text flagged
**Given** a hardcoded English string in source **When** rendered in `en-XA` **Then** the snapshot reveals it (un-pseudo'd) and CI flags the offending file.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `all`)
- [ ] RTL-tested

## Files
- `scripts/generate-pseudo-locales.sh`
- `HogwartsTests/locale/pseudo-locale-tests.swift` — snapshot driver
- `.github/workflows/i18n.yml` — CI job extension

## API Contract
- None.

## i18n Keys
- None.

## Tests
- See AC-2.

## Dependencies
- Depends on: LOC-002
- Blocks: every feature epic that ships UI

## Definition of Done
- [ ] AC met, pseudo snapshots checked in, CI gate active, fixture hardcoded string is flagged
