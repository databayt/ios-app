# EXAM-009: Retake Flow

**Epic**: EXAMS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to request and take a retake when allowed
**So that** I can improve a previous score per school policy

## Acceptance Criteria

### AC-1: Eligibility check
**Given** an exam allows retakes and the student is eligible **When** they open results **Then** a "Request retake" CTA appears with policy details.

### AC-2: Request flow
**Given** the student requests retake **When** confirmed **Then** server creates a retake session and routes them to EXAM-003 lockdown view.

### AC-3: Cap enforced
**Given** retake limit is reached **When** the student opens results **Then** the CTA is disabled with reason text.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`, `results`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Audit logged

## Files
- `hogwarts/features/exams/views/retake-request-view.swift`
- `hogwarts/features/exams/viewmodels/retake-viewmodel.swift`

## API Contract
- `POST /api/mobile/exams/:id/retake` — `{}` → `{ retake_session_id, allowed }`

## i18n Keys
- `marking.exam.retake_cta`, `marking.exam.retake_policy`, `marking.exam.retake_cap_reached`

## Tests
- `HogwartsTests/exams/retake-tests.swift`

## Dependencies
- Depends on: EXAM-007
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
