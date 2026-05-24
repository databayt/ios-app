# SEC-001: Cert Pinning + Rotation Strategy

**Epic**: Q-SECURITY
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M (5)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** TLS certificate pinning with a rotation strategy
**So that** MITM attacks are mitigated without breakage on renewal

## Acceptance Criteria

### AC-1: Pinning enforced
**Given** API requests
**When** the server's leaf cert is unexpected
**Then** the request fails closed (no fallback)

### AC-2: Rotation window
**Given** cert rotation approaches
**When** the app is updated with overlapping pin set
**Then** both old and new pins are accepted during the window

### AC-3: Proxy attack test
**Given** Charles/mitmproxy with custom CA
**When** a sensitive call is made
**Then** the proxy MITM is rejected

## Cross-Cutting Invariants
- [ ] schoolId-scoped data unchanged
- [ ] Audit log on pin failures

## Files
- `hogwarts/core/networking/cert-pinner.swift`
- `hogwarts/core/networking/api-client.swift`

## API Contract
- (none — transport-layer)

## i18n Keys
- (none)

## Tests
- `HogwartsTests/security/cert-pinning-tests.swift`

## Dependencies
- Depends on: CORE-010
- Blocks: SEC-007

## Definition of Done
- [ ] AC met, proxy test passes, rotation playbook documented
