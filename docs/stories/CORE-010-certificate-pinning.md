# CORE-010: Certificate Pinning via URLSessionDelegate

**Epic**: F-CORE
**Priority**: P0
**Phase**: M1
**Status**: done
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** security-minded org
**I want** TLS pinning against `*.databayt.org` certificates
**So that** even with a compromised CA, MITM tools cannot intercept iOS traffic

## Acceptance Criteria

### AC-1: Pinned hash matches
**Given** a request to a `databayt.org` host **When** TLS handshake completes **Then** the leaf-cert SPKI hash is compared to the bundled set; mismatch aborts.

### AC-2: Two-cert rotation window
**Given** a cert rotation in flight **When** both old and new pins are bundled **Then** either valid hash succeeds.

### AC-3: Non-pinned hosts pass
**Given** a request to a third-party host (e.g., Sentry) **When** observed **Then** the delegate falls through to default trust evaluation.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `errors`)
- [ ] Audit logged (pinning failure → security event)

## Files
- `hogwarts/core/api/pinning-delegate.swift` — `URLSessionDelegate` impl
- `hogwarts/core/api/pinned-hashes.swift` — embedded SPKI hashes (two-cert window)

## API Contract
- None (transport layer).

## i18n Keys
- `errors.security.pinning_failed`

## Tests
- `HogwartsTests/core/api/pinning-delegate-tests.swift` — valid/invalid leaf, third-party pass-through

## Dependencies
- Depends on: CORE-001
- Blocks: production cut

## Definition of Done
- [ ] AC met, MITM proxy (Charles) is rejected, rotation window verified
