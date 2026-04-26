# TT-004: Class Detail

**Epic**: TIMETABLE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want to tap any class in any timetable view to see its full detail (subject, teacher, room, students), so that I have context.

## Acceptance Criteria
### AC-1: Detail renders
**Given** I tap a class row **When** Detail opens **Then** I see subject, teacher, room, day/time, and conditional student list (teacher/admin only).

### AC-2: Action sheet
**Given** I am a teacher **When** I tap "..." **Then** I see actions: Mark Attendance, Open Class Stream, Add to Calendar.

### AC-3: Cross-cutting
Class/subject in entity.lang. Student names visible only when role permits. RTL action sheet. Times localized.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `attendance`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student list visibility)
- [ ] Audit logged (n/a — read-only)

## Files
- `hogwarts/features/timetable/views/class-detail-view.swift`
- `hogwarts/features/timetable/viewmodels/class-detail-viewmodel.swift`
- `hogwarts/features/timetable/services/class-detail-service.swift`

## API Contract
- `GET /api/mobile/classes/:id` → `{ id, subject, teacher, room, schedule, students? }`

## i18n Keys
- `common.class.detail`, `common.class.teacher`, `common.class.room`, `common.class.students`

## Tests
- `HogwartsTests/timetable/class-detail-tests.swift`
- Role-gated student list test

## Dependencies
- Depends on: TT-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated student list verified, parity preserved
