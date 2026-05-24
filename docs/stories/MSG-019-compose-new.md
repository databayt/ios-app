# MSG-019: Compose New Conversation (1:1 + Group)

**Epic**: MESSAGING
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to start a new 1:1 or group conversation
**So that** I can initiate communication with chosen people

## Acceptance Criteria

### AC-1: Picker mode
**Given** the user taps "New" **When** the picker opens **Then** they choose 1:1 or Group; for group, multiple selection is enabled.

### AC-2: Existing 1:1
**Given** a 1:1 already exists with the chosen user **When** the user taps Continue **Then** the existing chat opens (no duplicate created).

### AC-3: Group creation
**Given** at least 2 people selected for Group **When** the user enters a name and taps Create **Then** a new conversation is created with all selected, the user as creator + admin.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messaging`)
- [ ] RTL-tested
- [ ] schoolId predicate (only same-school members can be added)
- [ ] Role-gated
- [ ] Audit logged on creation

## Files
- `hogwarts/features/messaging/views/compose-new-view.swift`
- `hogwarts/features/messaging/viewmodels/compose-viewmodel.swift`
- `hogwarts/features/messaging/services/compose-service.swift`

## API Contract
- `POST /api/mobile/conversations` — `{ kind: "direct" | "group", name?, member_ids: [...] }` → `{ id }`

## i18n Keys
- `messaging.compose.new`, `messaging.compose.group_name`, `messaging.compose.create`

## Tests
- `HogwartsTests/messaging/compose-tests.swift`

## Dependencies
- Depends on: MSG-018
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
