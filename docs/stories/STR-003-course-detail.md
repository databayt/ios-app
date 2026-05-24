# STR-003: Course detail

**Epic**: STREAM
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [student]
**Multi-Tenant**: required

## User Story
**As a** student
**I want** course detail with syllabus and enroll CTA
**So that** I decide before enrolling

## Acceptance Criteria

### AC-1: Detail
**Given** course **When** detail loads **Then** title, instructor, syllabus body, chapters preview, duration, prerequisites.

### AC-2: Enroll
**Given** not enrolled **When** I tap "Enroll" **Then** server enrolls; appears in STR-002.

### AC-3: Cross-cutting
**Given** body in `course.lang` **When** rendering **Then** font + direction respected; translate affordance.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Entity content lang
- [ ] Audit logged on enroll

## Files
- `hogwarts/features/stream/views/course-detail-view.swift`
- `hogwarts/features/stream/viewmodels/course-detail-viewmodel.swift`
- `hogwarts/features/stream/services/stream-actions.swift` — `enroll(id)`

## API Contract
- `GET /api/mobile/stream/courses/:id` — `{ id, title, body, lang, instructor, chapters:[...], duration_min, prerequisites }`
- `POST /api/mobile/stream/enrollments` — `{ course_id } → { id }` (P2 backend)

## i18n Keys
- `common.stream.course.syllabus`
- `common.stream.course.enroll`
- `common.stream.course.prerequisites`

## Tests
- `HogwartsTests/stream/course-detail-tests.swift`

## Dependencies
- Depends on: STR-001
- Blocks: STR-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
