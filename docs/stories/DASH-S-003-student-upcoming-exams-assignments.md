# DASH-S-003: Student Upcoming Exams + Assignments

**Epic**: DASHBOARD
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
As a student, I want to see the next 5 exams and assignment due dates, so that I can plan my week.

## Acceptance Criteria
### AC-1: List next 5
**Given** dashboard loads **When** the section renders **Then** I see up to 5 upcoming items, sorted ascending by date, each with subject and due-by.

### AC-2: Empty state
**Given** I have nothing upcoming **When** the section renders **Then** I see a friendly empty state, not blank.

### AC-3: Cross-cutting
Dates locale-formatted. RTL list reads trailing-leading. Subject names in entity.lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `assignments`, `exams`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (student only)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/dashboard/views/student-upcoming-list.swift`
- `hogwarts/features/dashboard/viewmodels/student-dashboard-viewmodel.swift`

## API Contract
- `GET /api/mobile/dashboard` → `{ upcoming: [{ kind: "exam"|"assignment", title, subject, dueAt }] }`

## i18n Keys
- `home.upcoming.title`, `home.upcoming.empty`, `home.upcoming.exam`, `home.upcoming.assignment`

## Tests
- `HogwartsTests/dashboard/student-upcoming-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: DASH-S-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, parity preserved
