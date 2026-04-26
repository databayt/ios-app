# PLT-006: Live Activity — Exam Timer

**Epic**: F-PLATFORM-CORE
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: M
**Roles**: [student]
**Multi-Tenant**: required

## User Story
As a student, I want a Live Activity that counts down the exam time, so that I see remaining minutes without leaving the question screen.

## Acceptance Criteria
### AC-1: Start on exam launch
**Given** the student starts an in-app exam **When** countdown begins **Then** a Live Activity starts with subject + duration.

### AC-2: Push-update remaining time
**Given** the Live Activity is live **When** the OS receives push token updates **Then** remaining time stays accurate without app foreground.

### AC-3: Submit ends activity
**Given** the student submits or runs out of time **When** that occurs **Then** the activity ends with a final state (Submitted / Time up).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `results`, `home`)
- [ ] RTL-tested
- [ ] schoolId scope (attributes carry tenant)
- [ ] Role-gated (student only)
- [ ] Audit logged on submit/auto-submit

## Files
- `hogwarts/core/live-activities/exam-timer-activity.swift` — ActivityAttributes
- `HogwartsWidgets/exam-timer-live-activity.swift` — Live Activity
- `hogwarts/features/exams/services/exam-runner-service.swift` — orchestration

## API Contract
- `POST /api/mobile/exams/{id}/start` — returns push token for ActivityKit updates
- `POST /api/mobile/exams/{id}/submit`

## i18n Keys
- `results.liveActivity.exam.title`
- `results.liveActivity.exam.timeup`
- `results.liveActivity.exam.submitted`

## Tests
- `HogwartsTests/live-activities/exam-timer-tests.swift`

## Dependencies
- Depends on: PLT-005
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
