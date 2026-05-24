# LOC-008: RTL Audit Per Screen — Snapshots Checked In

**Epic**: F-LOCALE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** team shipping an Arabic-default app
**I want** every screen to have an RTL snapshot in `tests/snapshots/rtl/`
**So that** RTL regressions are visible in PR diffs

## Acceptance Criteria

### AC-1: Snapshot per screen
**Given** every existing screen **When** snapshot tests run **Then** an `ar` (RTL) PNG exists under `tests/snapshots/rtl/<screen>/`.

### AC-2: No `.left/.right` modifiers
**Given** the Swift source **When** grepped **Then** zero `.leading`-replaceable `.left`/`.right` instances remain (audit script clean).

### AC-3: Mirrored chevrons
**Given** any directional SF Symbol **When** rendered **Then** `.flipsForRightToLeftLayoutDirection` is applied where appropriate.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: per-feature)
- [ ] RTL-tested (this IS the RTL gate)

## Files
- `tests/snapshots/rtl/*` — checked-in screenshots
- `scripts/audit-left-right.sh` — grep gate
- Per-screen fixes filed under owning feature epics

## API Contract
- None.

## i18n Keys
- None.

## Tests
- `HogwartsTests/locale/rtl-snapshot-tests.swift` — snapshot driver per screen

## Dependencies
- Depends on: LOC-004
- Blocks: every UI-bearing feature epic gate

## Definition of Done
- [ ] AC met, audit script clean, snapshots committed, follow-up tickets per screen
