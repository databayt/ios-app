# SHR-004: AirDrop Tenant-Aware Deep Links

**Epic**: F-SHARING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want AirDrop to send entity deep links to nearby devices, so that colleagues can jump straight into a shared item.

## Acceptance Criteria
### AC-1: AirDrop activity present
**Given** a ShareLink invocation **When** AirDrop devices are nearby **Then** AirDrop appears in the share sheet first.

### AC-2: Receive flow
**Given** the recipient AirDrops a kingfahad.databayt.org link **When** their app is installed **Then** the universal link routes to the entity detail.

### AC-3: Cross-tenant guard
**Given** sender and receiver belong to different schools **When** the link opens **Then** receiver sees a tenant-mismatch screen with sign-in or switch options.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `errors`)
- [ ] RTL-tested
- [ ] schoolId scope (link verifies tenant on receive)
- [ ] Audit logged on cross-tenant attempts

## Files
- `hogwarts/core/sharing/share-link-helpers.swift` — URL with schoolId
- `hogwarts/app/universal-link-router.swift` — tenant guard
- `hogwarts/features/auth/views/tenant-mismatch-view.swift` — error UI

## API Contract
None — universal link + JWT verification client-side.

## i18n Keys
- `errors.tenantMismatch.title`
- `errors.tenantMismatch.body`
- `errors.tenantMismatch.switchSchool`

## Tests
- `HogwartsTests/sharing/airdrop-deep-link-tests.swift`
- Cross-tenant routing test

## Dependencies
- Depends on: SHR-001, AUTH-014
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
