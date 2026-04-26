# EXAM-006: Submit + Confirmation

**Epic**: EXAMS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to submit my exam and see a confirmation
**So that** I am sure my work was sent to the server

## Acceptance Criteria

### AC-1: Submit guard
**Given** unanswered questions remain **When** the student taps Submit **Then** a warning lists unanswered numbers and asks for confirmation.

### AC-2: Final POST
**Given** the student confirms submit **When** the request fires **Then** all answers persist, the session is closed server-side, and a success view appears.

### AC-3: Idempotent
**Given** a network blip after submit **When** the user retries **Then** the server returns the existing submission (idempotency key) without duplicating.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated
- [ ] Audit logged

## Files
- `hogwarts/features/exams/views/exam-submit-view.swift`
- `hogwarts/features/exams/viewmodels/exam-taking-viewmodel.swift`

## API Contract
- `POST /api/mobile/exams/:id/submit` — `{ session_token, idempotency_key }` → `{ submission_id, submitted_at }`

## i18n Keys
- `marking.exam.submit`, `marking.exam.submit_warning`, `marking.exam.submitted`

## Tests
- `HogwartsTests/exams/submit-tests.swift`
- Idempotency test

## Dependencies
- Depends on: EXAM-004
- Blocks: EXAM-007

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
