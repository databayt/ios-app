# GRD-003: Child profile detail

**Epic**: GUARDIAN-LINK
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** a child profile with class, teachers, contact, blood group
**So that** I have key info quickly

## Acceptance Criteria

### AC-1: Detail
**Given** GRD-001 row tap **When** detail loads **Then** shows class, teachers, blood type, allergies, emergency contact.

### AC-2: Edit limited fields
**Given** detail **When** I tap "Edit" **Then** only allergies + emergency contact editable; submitted to server.

### AC-3: Cross-cutting
**Given** mutation **When** sent **Then** `school_id` enforced; audit logged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested
- [ ] schoolId on PATCH
- [ ] Audit logged
- [ ] Role gate (guardian only)
- [ ] Entity content lang for child name + teacher names

## Files
- `hogwarts/features/guardian/views/child-profile-detail-view.swift`
- `hogwarts/features/guardian/viewmodels/child-profile-viewmodel.swift`
- `hogwarts/features/guardian/services/guardian-actions.swift`

## API Contract
- `GET /api/mobile/guardian/children/:childId` — `{ ..., class, teachers, blood_type, allergies, emergency_contact }`
- `PATCH /api/mobile/guardian/children/:childId` — `{ allergies, emergency_contact }`

## i18n Keys
- `profile.child.class`
- `profile.child.teachers`
- `profile.child.blood_type`
- `profile.child.allergies`
- `profile.child.emergency_contact`

## Tests
- `HogwartsTests/guardian/child-profile-tests.swift`

## Dependencies
- Depends on: GRD-001, GRD-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
