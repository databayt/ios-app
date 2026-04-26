# WB-001: Health Record View

**Epic**: WELLBEING
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M (5)
**Roles**: [guardian, teacher]
**Multi-Tenant**: required

## User Story
**As a** guardian or class teacher
**I want** to view a student's health record (allergies, conditions, emergency contacts)
**So that** I can respond appropriately in an emergency

## Acceptance Criteria

### AC-1: Render record with allergies highlighted
**Given** the user has permission to view the student
**When** they open the health record
**Then** allergies render with a high-contrast badge and emergency contacts are clickable to call

### AC-2: Permission gate (teacher scope)
**Given** a teacher user
**When** they request health for a student NOT in their class
**Then** a localized "Not authorized" message is shown

### AC-3: Screenshot/recording prevention
**Given** the user is on the health record screen
**When** they attempt screenshot or screen recording
**Then** content is masked via blur on `UIScreen.captured`

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: guardian (own children) / teacher (own classes)
- [ ] Sensitive data: no clipboard, no screenshot

## Files
- `hogwarts/features/wellbeing/views/health-record-view.swift`
- `hogwarts/features/wellbeing/viewmodels/health-record-viewmodel.swift`
- `hogwarts/features/wellbeing/services/wellbeing-service.swift`
- `hogwarts/features/wellbeing/models/health-record.swift`

## API Contract
- `GET /api/mobile/wellbeing/health/:studentId` → `{ allergies: [], conditions: [], emergency_contacts: [] }`

## i18n Keys
- `profile.health.title`, `allergies`, `conditions`, `emergency_contacts`
- `profile.health.not_authorized`

## Tests
- `HogwartsTests/wellbeing/health-record-tests.swift`
- Screenshot prevention test

## Dependencies
- Depends on: AUTH-006, CORE-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role gate verified, screenshot blocked
