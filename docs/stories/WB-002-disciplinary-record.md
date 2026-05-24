# WB-002: Disciplinary Record (Read-Only with Appeal)

**Epic**: WELLBEING
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M (5)
**Roles**: [guardian, student]
**Multi-Tenant**: required

## User Story
**As a** guardian or student
**I want** to view the disciplinary record and submit appeals
**So that** I can respond to incidents through formal channels

## Acceptance Criteria

### AC-1: List incidents
**Given** the user has permission
**When** they open disciplinary record
**Then** incidents render with date, severity, and entity content in `entity.lang`

### AC-2: Submit appeal
**Given** an incident is appealable
**When** user taps "Appeal" and submits localized text
**Then** an appeal record is created and visible in status

### AC-3: Read-only restrictions
**Given** the record is read-only
**When** the user attempts to edit a non-appeal field
**Then** UI prevents the action; edits only via appeal flow

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: guardian (own children) / student (self)
- [ ] Audit log on appeal submit
- [ ] Entity content rendered with `entity.lang`

## Files
- `hogwarts/features/wellbeing/views/disciplinary-record-view.swift`
- `hogwarts/features/wellbeing/views/appeal-form-view.swift`
- `hogwarts/features/wellbeing/viewmodels/disciplinary-viewmodel.swift`
- `hogwarts/features/wellbeing/services/wellbeing-service.swift`

## API Contract
- `GET /api/mobile/wellbeing/discipline/:studentId` → `{ incidents: [] }`
- `POST /api/mobile/wellbeing/discipline/:incidentId/appeal` — `{ text }` → `{ id, status }`

## i18n Keys
- `profile.discipline.title`, `incident`, `severity`, `appeal`
- `profile.discipline.appeal_submitted`

## Tests
- `HogwartsTests/wellbeing/disciplinary-record-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit logged, entity.lang verified
