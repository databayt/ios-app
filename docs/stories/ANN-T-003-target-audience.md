# ANN-T-003: Target audience (role/class/grade)

**Epic**: ANNOUNCE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin]
**Multi-Tenant**: required

## User Story
**As an** admin
**I want** to target an announcement to a role, class, or grade
**So that** only relevant users see it

## Acceptance Criteria

### AC-1: Audience picker
**Given** composer **When** I open "Audience" **Then** I can select `roles[]`, `classes[]`, `grades[]` (multi-select); default = entire school.

### AC-2: Filtered delivery
**Given** I publish targeted to "Grade 9" **When** a Grade 8 student opens feed **Then** they do NOT see it.

### AC-3: Cross-cutting
**Given** another school's class id is provided **When** request validated server-side **Then** rejected with 403 (cross-tenant).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messages`)
- [ ] RTL-tested audience picker
- [ ] schoolId enforced; class/grade ids belong to schoolId
- [ ] Role gate (admin only)
- [ ] Audit logged with audience snapshot

## Files
- `hogwarts/features/announcements/views/audience-picker-view.swift` — multi-select tree
- `hogwarts/features/announcements/viewmodels/audience-viewmodel.swift` — fetches school's classes/grades
- `hogwarts/features/announcements/services/announcement-actions.swift` — `publish(audience:)`

## API Contract
- `GET /api/mobile/admin/audiences` — `{ roles[], classes[], grades[] }` scoped to school
- `POST /api/mobile/announcements` — body adds `audience: { roles[], class_ids[], grade_ids[] }`

## i18n Keys
- `messages.audience.title`
- `messages.audience.role`
- `messages.audience.class`
- `messages.audience.grade`
- `messages.audience.everyone`

## Tests
- `HogwartsTests/announcements/audience-tests.swift`
- Multi-tenant isolation test, audience filter test

## Dependencies
- Depends on: ANN-T-001
- Blocks: ANN-T-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId verified, audit row exists
