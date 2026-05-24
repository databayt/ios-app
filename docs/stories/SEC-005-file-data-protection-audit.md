# SEC-005: File Data Protection Class Audit

**Epic**: Q-SECURITY
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: XS (2)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** every persisted file to use the strongest applicable data protection class
**So that** at-rest data is encrypted when device is locked

## Acceptance Criteria

### AC-1: Default to `.completeFileProtection`
**Given** file writes
**When** auditor runs
**Then** documents directory and SwiftData store use `.completeFileProtection` or `.completeUntilFirstUserAuthentication` per use case

### AC-2: Background-required exceptions justified
**Given** files needing background access
**When** flagged
**Then** the file uses `.completeUntilFirstUserAuthentication` with a comment justifying it

### AC-3: CI gate
**Given** new file APIs added
**When** code is reviewed
**Then** lint enforces explicit protection class

## Cross-Cutting Invariants
- [ ] schoolId-scoped paths
- [ ] No PII in unprotected files

## Files
- `hogwarts/core/storage/file-helpers.swift`
- `hogwarts/scripts/lint-file-protection.sh`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/security/file-protection-tests.swift`

## Dependencies
- Depends on: —
- Blocks: SEC-007

## Definition of Done
- [ ] AC met, lint active, every file flagged
