# SEC-008: Penetration Test Pre-Launch

**Epic**: Q-SECURITY
**Priority**: P1
**Phase**: M2
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** a third-party pen test before public launch
**So that** critical issues surface before users do

## Acceptance Criteria

### AC-1: Engagement scope
**Given** pen test starts
**When** scope is signed
**Then** scope covers transport, storage, IPC, auth, session, biometrics

### AC-2: Zero critical findings before ship
**Given** report delivered
**When** triaged
**Then** all critical/high findings are fixed and re-tested

### AC-3: Findings docketed
**Given** lower-severity items
**When** logged
**Then** issues exist in tracker with owners and timeline

## Cross-Cutting Invariants
- [ ] schoolId scoping verified
- [ ] Multi-tenant isolation verified

## Files
- `docs/security/pentest-report-vN.md`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- External pen test report

## Dependencies
- Depends on: SEC-007
- Blocks: SHIP-007

## Definition of Done
- [ ] AC met, zero critical at launch, report archived
