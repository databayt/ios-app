# EXAM-005: Violation Detection (App Switch, Screenshot)

**Epic**: EXAMS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student (and proctor)
**I want** the app to detect and log integrity violations during an exam
**So that** academic honesty is enforced and reviewable by faculty

## Acceptance Criteria

### AC-1: App switch
**Given** an exam is in progress **When** `UIApplication.willResignActive` fires **Then** a violation event is logged with `school_id`, `exam_id`, `type=app_switch`, timestamp.

### AC-2: Screenshot
**Given** an exam is in progress **When** `UIScreen.didCaptureNotification` fires **Then** a violation event is logged with `type=screenshot`.

### AC-3: Warning banner
**Given** a violation has been logged **When** the student returns to the exam **Then** a warning banner appears: "Activity logged for review".

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate (every violation includes school)
- [ ] Role-gated
- [ ] Audit logged on every violation

## Files
- `hogwarts/features/exams/services/violation-detector.swift`
- `hogwarts/features/exams/viewmodels/exam-taking-viewmodel.swift`

## API Contract
- `POST /api/mobile/exams/:id/violations` — `{ type, occurred_at, evidence? }` → `{ violation_id }`

## i18n Keys
- `marking.exam.violation_warning`, `marking.exam.violation_logged`

## Tests
- `HogwartsTests/exams/violation-detection-tests.swift`
- Multi-tenant isolation

## Dependencies
- Depends on: EXAM-003, CORE-006
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
