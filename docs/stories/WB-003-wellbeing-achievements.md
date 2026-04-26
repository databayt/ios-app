# WB-003: Achievements Showcase

**Epic**: WELLBEING
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S (3)
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** student or guardian
**I want** to view a showcase of student achievements
**So that** progress and recognition are visible

## Acceptance Criteria

### AC-1: Render achievements grid
**Given** the student has earned achievements
**When** they open the showcase
**Then** items render with date, title in `entity.lang`, badge image

### AC-2: Empty state
**Given** no achievements yet
**When** the screen loads
**Then** localized empty state with illustration is shown

### AC-3: Share single achievement
**Given** an achievement card
**When** the user taps share
**Then** SwiftUI ShareLink opens with localized title + image

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: student (self) / guardian (own children)
- [ ] Entity content rendered with `entity.lang`

## Files
- `hogwarts/features/wellbeing/views/achievements-showcase-view.swift`
- `hogwarts/features/wellbeing/viewmodels/achievements-viewmodel.swift`
- `hogwarts/features/wellbeing/services/wellbeing-service.swift`

## API Contract
- `GET /api/mobile/wellbeing/achievements/:studentId` → `{ items: [{ id, title, badge_url, awarded_at }] }`

## i18n Keys
- `profile.achievements.title`, `empty`, `share`

## Tests
- `HogwartsTests/wellbeing/achievements-tests.swift`

## Dependencies
- Depends on: AUTH-006
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, share verified
