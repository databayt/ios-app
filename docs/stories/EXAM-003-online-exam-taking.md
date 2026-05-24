# EXAM-003: Online Exam Taking (Timer, Navigation, Lockdown)

**Epic**: EXAMS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: XL
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to take an online exam in a focused, lockdown-style mode with a timer and question navigator
**So that** I can complete it under proctored conditions on the device

## Acceptance Criteria

### AC-1: Lockdown shell
**Given** an exam is started **When** the lockdown view loads **Then** share sheet, screenshot APIs, and other navigation are disabled; the screen shows timer, current question, navigator drawer.

### AC-2: Timer never drifts
**Given** an exam runs for 60 minutes **When** the device sleeps and wakes **Then** the timer reflects wall-clock elapsed time, not just process uptime.

### AC-3: Question navigation
**Given** the student opens the navigator **When** they tap a question number **Then** the view jumps to that question; answered/unanswered states are color coded.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested (timer + navigator mirror)
- [ ] schoolId predicate
- [ ] Role-gated to student
- [ ] Question text in `entity.lang`

## Files
- `hogwarts/features/exams/views/exam-taking-view.swift`
- `hogwarts/features/exams/views/question-navigator.swift`
- `hogwarts/features/exams/viewmodels/exam-taking-viewmodel.swift`
- `hogwarts/features/exams/services/lockdown-service.swift`

## API Contract
- `GET /api/mobile/exams/:id/start` — issues a session token + `{ questions: [...] }`

## i18n Keys
- `marking.exam.timer`, `marking.exam.question_n`, `marking.exam.navigator`, `marking.exam.lockdown_warning`

## Tests
- `HogwartsTests/exams/exam-taking-tests.swift`
- Snapshots AR + EN
- Timer drift test (simulate sleep/wake)

## Dependencies
- Depends on: EXAM-002
- Blocks: EXAM-004, EXAM-005, EXAM-006

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
