# LOC-002: String Parity Tooling + CI Gate

**Epic**: F-LOCALE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** team committed to bilingual parity
**I want** `scripts/check-string-parity.sh` running on every PR
**So that** any new EN key without a matching AR pair fails CI

## Acceptance Criteria

### AC-1: Parity script
**Given** the catalog **When** `scripts/check-string-parity.sh` runs **Then** it computes EN/AR parity %, prints any keys missing in AR, and exits non-zero if parity < 99%.

### AC-2: CI gate
**Given** a PR **When** GitHub Actions runs **Then** the parity job blocks merge on failure.

### AC-3: TODO placeholder accepted
**Given** a new EN key **When** AR is `// TODO(translate)` **Then** parity treats it as present (counted, but flagged in PR comment).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `all`)

## Files
- `scripts/check-string-parity.sh` — parity calculator
- `.github/workflows/i18n.yml` — CI job

## API Contract
- None.

## i18n Keys
- None.

## Tests
- `scripts/check-string-parity.sh` self-tests against fixture catalogs (in-tree fixtures)

## Dependencies
- Depends on: LOC-001
- Blocks: LOC-003, every PR

## Definition of Done
- [ ] AC met, CI gate active, fixture tests pass, sample PR with missing key blocked
