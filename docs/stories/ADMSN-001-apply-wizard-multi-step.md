# ADMSN-001: Apply Wizard (Multi-Step)

**Epic**: ADMISSION
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: L (8)
**Roles**: [user]
**Multi-Tenant**: required

## User Story
**As a** prospective parent (no account)
**I want** to complete a multi-step admission application
**So that** I can apply without creating an account first

## Acceptance Criteria

### AC-1: Multi-step flow with progress
**Given** the user taps "Apply"
**When** wizard launches
**Then** 4 steps render (student info, guardian info, prior school, declaration) with localized progress

### AC-2: Save and resume
**Given** the user closes mid-flow
**When** they reopen
**Then** progress resumes from last completed step (local SwiftData draft)

### AC-3: Submission validation
**Given** required fields are missing on submit
**When** user taps "Submit"
**Then** localized inline errors appear, scroll to first invalid field

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `errors`)
- [ ] RTL-tested
- [ ] schoolId from public school context
- [ ] Role gate: public (no auth)
- [ ] Audit log on submit (server-side)

## Files
- `hogwarts/features/admission/views/apply-wizard-view.swift`
- `hogwarts/features/admission/viewmodels/apply-wizard-viewmodel.swift`
- `hogwarts/features/admission/services/admission-service.swift`
- `hogwarts/features/admission/models/application-draft.swift`

## API Contract
- `POST /api/mobile/admission/applications` — `{ student, guardian, prior_school, declaration }` → `{ application_id, otp_sent }`

## i18n Keys
- `common.admission.step_student`, `step_guardian`, `step_school`, `step_declaration`
- `common.admission.submit`, `errors.required_field`

## Tests
- `HogwartsTests/admission/apply-wizard-tests.swift`

## Dependencies
- Depends on: CORE-001
- Blocks: ADMSN-002, ADMSN-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, draft persists, validation works
