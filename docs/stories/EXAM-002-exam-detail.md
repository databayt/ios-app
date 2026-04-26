# EXAM-002: Exam Detail (Date, Room, Subjects, Syllabus)

**Epic**: EXAMS
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** to view exam details including syllabus, room, and start time
**So that** I am fully informed before sitting for the exam

## Acceptance Criteria

### AC-1: Detail sections
**Given** the user opens an exam **When** the detail loads **Then** sections show Subject, Date + Time, Room, Duration, Syllabus, and Instructions.

### AC-2: Syllabus in author lang
**Given** the syllabus is in Arabic **When** rendered in an English app **Then** the text uses Arabic font + RTL with a Translate affordance.

### AC-3: Add to calendar
**Given** the detail is shown **When** the user taps "Add to Calendar" **Then** an EventKit event is created in the default calendar.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to student
- [ ] Syllabus respects `entity.lang`

## Files
- `hogwarts/features/exams/views/exam-detail-view.swift`
- `hogwarts/features/exams/viewmodels/exam-detail-viewmodel.swift`

## API Contract
- `GET /api/mobile/exams/:id` — `{ id, subject, start_at, end_at, room, syllabus, syllabus_lang, instructions }`

## i18n Keys
- `marking.exam.subject`, `marking.exam.room`, `marking.exam.syllabus`, `marking.exam.add_to_calendar`

## Tests
- `HogwartsTests/exams/exam-detail-tests.swift`
- Snapshots AR + EN

## Dependencies
- Depends on: EXAM-001, INT-001
- Blocks: EXAM-003

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
