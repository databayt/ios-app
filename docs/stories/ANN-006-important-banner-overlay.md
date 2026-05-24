# ANN-006: Important banner overlay (P0 announcements)

**Epic**: ANNOUNCE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** school user
**I want** P0 announcements to overlay the app
**So that** I cannot miss critical alerts (closure, evacuation)

## Acceptance Criteria

### AC-1: Overlay
**Given** a P0 announcement arrives **When** app is foregrounded **Then** a modal banner overlay appears regardless of current view.

### AC-2: Acknowledgment
**Given** banner shown **When** I tap "I understand" **Then** banner dismisses and read-receipt is recorded (ANN-003).

### AC-3: Cross-cutting
**Given** P0 in `entity.lang` **When** banner renders **Then** body uses `entity.lang` font + direction; banner chrome is in app lang.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messages`)
- [ ] RTL-tested banner
- [ ] schoolId scope (only current school's P0)
- [ ] Audit logged on acknowledge
- [ ] Entity content lang respected

## Files
- `hogwarts/features/announcements/views/important-banner-overlay.swift` — modal overlay
- `hogwarts/core/observability/foreground-observer.swift` — checks for P0 on foreground
- `hogwarts/features/announcements/viewmodels/feed-viewmodel.swift` — emits P0

## API Contract
- (consumes ANN-001 with `important=true`)
- `POST /api/mobile/announcements/:id/acknowledge` — `{} → { acknowledged_at }`

## i18n Keys
- `messages.banner.title`
- `messages.banner.acknowledge`

## Tests
- `HogwartsTests/announcements/banner-tests.swift`
- Snapshot AR + EN, dynamic type XL

## Dependencies
- Depends on: ANN-001, ANN-003
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
