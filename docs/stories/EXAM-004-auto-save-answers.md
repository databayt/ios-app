# EXAM-004: Auto-Save Answers

**Epic**: EXAMS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** my answers auto-saved during the exam
**So that** I never lose work if the app crashes or the device dies

## Acceptance Criteria

### AC-1: Auto-save every 10s
**Given** the student is taking an exam **When** 10 seconds elapse since the last change **Then** unsaved answers POST to the server with the session token.

### AC-2: Background save
**Given** the app moves to background **When** the lifecycle event fires **Then** answers immediately persist locally and to the server before suspension.

### AC-3: Recover on relaunch
**Given** the app crashes mid-exam **When** the student relaunches **Then** the exam reopens at the last answered question with all previous answers restored.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested (save indicator placement)
- [ ] schoolId predicate
- [ ] Role-gated to student
- [ ] Audit logged on submit

## Files
- `hogwarts/features/exams/services/auto-save-service.swift`
- `hogwarts/features/exams/viewmodels/exam-taking-viewmodel.swift`

## API Contract
- `POST /api/mobile/exams/:id/answers` — `{ session_token, answers: [{ q_id, value }] }` → `{ saved_at }`

## i18n Keys
- `marking.exam.saving`, `marking.exam.saved`, `marking.exam.save_failed`

## Tests
- `HogwartsTests/exams/auto-save-tests.swift`
- Crash recovery test

## Dependencies
- Depends on: EXAM-003
- Blocks: EXAM-006

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
