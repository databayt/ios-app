# ID-004: ID card share

**Epic**: IDCARD
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** to share my ID card (PDF or QR)
**So that** I can submit it for verification

## Acceptance Criteria

### AC-1: Share sheet
**Given** ID-001 **When** I tap share **Then** ShareLink presents PDF (ID-003) + QR image options.

### AC-2: Cross-cutting
**Given** shared payload **When** received **Then** filename includes `<schoolId>` to avoid mix-ups; no PII beyond what's on the card.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested
- [ ] schoolId in filename
- [ ] No PII leak

## Files
- `hogwarts/features/idcard/views/idcard-view.swift` — ShareLink

## API Contract
- (consumes ID-003 PDF endpoint)

## i18n Keys
- `profile.idcard.share`

## Tests
- `HogwartsTests/idcard/share-tests.swift`

## Dependencies
- Depends on: ID-003
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, schoolId in filename verified
