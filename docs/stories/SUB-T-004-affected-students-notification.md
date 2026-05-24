# SUB-T-004: Affected Students Notification

**Epic**: SUBSTITUTION
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: S (2)
**Roles**: [student, guardian]
**Multi-Tenant**: required

## User Story
**As a** student or guardian
**I want** to be notified when my class has a substitute teacher
**So that** I know who is teaching today

## Acceptance Criteria

### AC-1: Receive substitute notification
**Given** an admin approves a substitution affecting the user's class
**When** the push lands
**Then** notification body is in the recipient's app language with substitute teacher name

### AC-2: Tap-through deep link
**Given** the notification is tapped
**When** app opens
**Then** user lands on the affected class detail showing today's substitute

### AC-3: Substitute name renders in entity content lang
**Given** substitute teacher's `entity.lang` differs from app lang
**When** the row renders
**Then** name uses entity content lang, labels use app lang

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role gate: student/guardian
- [ ] Entity content rendered with `entity.lang`

## Files
- `hogwarts/features/substitution/views/substitute-banner-view.swift` — banner on class card
- `hogwarts/features/substitution/viewmodels/substitute-banner-viewmodel.swift`
- `hogwarts/core/notifications/notification-router.swift` — deep link handler

## API Contract
- `GET /api/mobile/teacher/substitutions/today` → `{ items: [{ class_id, substitute_teacher }] }`

## i18n Keys
- `common.substitution.substitute_today`
- `common.substitution.notification_body`

## Tests
- `HogwartsTests/substitution/affected-notification-tests.swift`

## Dependencies
- Depends on: SUB-T-003, NOTIF (push infra)
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, deep link verified, entity.lang verified
