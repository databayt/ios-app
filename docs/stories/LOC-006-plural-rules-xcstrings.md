# LOC-006: Plural Rules (xcstrings stringSetVariations)

**Epic**: F-LOCALE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As an** Arabic-speaking user
**I want** counts to use Arabic's six plural categories (zero/one/two/few/many/other)
**So that** "you have N messages" is grammatically correct

## Acceptance Criteria

### AC-1: Plural-bearing keys converted
**Given** a count-bearing key **When** edited in `Localizable.xcstrings` **Then** it carries `stringSetVariations.plural` with all six AR categories and English's two.

### AC-2: SwiftUI consumes correctly
**Given** `Text("messages.you_have_n_messages \(count)")` **When** rendered **Then** the right plural variant displays for `count` 0, 1, 2, 3, 11, 100 in both AR and EN.

### AC-3: Tooling
**Given** `scripts/audit-plurals.sh` **When** run **Then** any count-passed key without plural variation is flagged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: per-feature)
- [ ] RTL-tested

## Files
- `hogwarts/Resources/Localizable.xcstrings` — add plural variations
- `scripts/audit-plurals.sh`

## API Contract
- None.

## i18n Keys
- `messaging.you_have_n_messages`, `notifications.n_unread`, `attendance.n_absences` (initial set)

## Tests
- `HogwartsTests/locale/plural-tests.swift` — all six AR categories assert correct string

## Dependencies
- Depends on: LOC-001
- Blocks: every count-bearing UI

## Definition of Done
- [ ] AC met, audit script clean, snapshot AR + EN at counts 0/1/2/3/11/100
