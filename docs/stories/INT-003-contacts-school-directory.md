# INT-003: Contacts Integration (School Directory)

**Epic**: F-INTEGRATION
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want to save school contacts (teachers, classmates, admin) into my iOS Contacts, so that I can call/message them from any app.

## Acceptance Criteria
### AC-1: Save contact happy path
**Given** a person profile **When** user taps "Save to Contacts" **Then** a CNContact is written with prefix `[<school_name>]` in the company field, role tag, and avatar.

### AC-2: Tenant prefix
**Given** user is in school A and saves teacher Ahmed **When** later switches to school B **Then** Ahmed's contact identifier carries `<schoolId>` prefix to avoid cross-tenant collision.

### AC-3: Permission denied
**Given** Contacts permission is denied **When** user attempts save **Then** an alert points to Settings.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested (Arabic name rendering)
- [ ] schoolId scope (identifier prefix)
- [ ] Role-gated (admin can export bulk; user only individuals)
- [ ] Audit logged

## Files
- `hogwarts/core/integration/contacts-service.swift` — CNContactStore wrapper
- `hogwarts/features/profile/views/profile-detail-view.swift` — CTA
- `hogwarts/features/messaging/views/conversation-detail-view.swift` — CTA

## API Contract
None — local Contacts framework.

## i18n Keys
- `common.contacts.save`
- `common.contacts.saved`
- `common.contacts.permissionDenied`
- `common.contacts.rationale`

## Tests
- `HogwartsTests/integration/contacts-service-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: AUTH-006
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
