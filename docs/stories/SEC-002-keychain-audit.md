# SEC-002: Keychain Audit (No UserDefaults for Tokens)

**Epic**: Q-SECURITY
**Priority**: P1
**Phase**: M0
**Status**: pending
**Effort**: XS (2)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** all sensitive material stored in Keychain only
**So that** UserDefaults exposure is impossible

## Acceptance Criteria

### AC-1: No tokens in UserDefaults
**Given** static analysis
**When** scan runs
**Then** zero matches for tokens/PII in UserDefaults

### AC-2: Keychain access groups correct
**Given** Keychain entries
**When** introspected
**Then** access group + accessibility set per data class

### AC-3: Wipe on logout/tenant switch
**Given** logout or tenant switch
**When** triggered
**Then** Keychain entries scoped to old session are deleted

## Cross-Cutting Invariants
- [ ] schoolId scoped Keychain entries
- [ ] Audit log on read/write

## Files
- `hogwarts/core/security/keychain-service.swift`
- `hogwarts/scripts/lint-userdefaults.sh`

## API Contract
- (none)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/security/keychain-audit-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: SEC-007

## Definition of Done
- [ ] AC met, lint active, zero UserDefaults token usage
