# SEC-007: OWASP MASVS L1 Audit

**Epic**: Q-SECURITY
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: L (8)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** a documented OWASP MASVS Level 1 audit to pass
**So that** the app meets baseline mobile security expectations

## Acceptance Criteria

### AC-1: All L1 controls reviewed
**Given** MASVS L1 control list
**When** every control is mapped to a story
**Then** each is implemented or marked N/A with justification

### AC-2: Audit report
**Given** review complete
**When** report is generated
**Then** report under `docs/security/masvs-l1.md` lists controls + evidence + status

### AC-3: External validator
**Given** report submitted
**When** an external reviewer signs off
**Then** the result is shipped with release notes

## Cross-Cutting Invariants
- [ ] schoolId-aware controls
- [ ] Strings/lint clean

## Files
- `docs/security/masvs-l1.md`
- `hogwarts/scripts/audit-masvs.sh`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- Audit-driven, evidence collated in report

## Dependencies
- Depends on: SEC-001..SEC-006
- Blocks: SEC-008, SHIP-007

## Definition of Done
- [ ] AC met, report committed, external sign-off recorded
