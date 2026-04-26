# PROF-005: Help Center

**Epic**: PROFILE
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want in-app help articles plus a contact-support shortcut, so that I can self-serve answers or escalate.

## Acceptance Criteria
### AC-1: Articles browse offline
**Given** the app launched once **When** I open Help offline **Then** I can read bundled articles by category.

### AC-2: Contact support
**Given** I tap "Contact Support" **When** the form opens **Then** I can compose subject + body, attach diagnostics, and submit; success shows a confirmation.

### AC-3: Cross-cutting
Articles localized AR + EN. RTL list ordering. Search-within-help works in both languages.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (support ticket)
- [ ] Role-gated (all)
- [ ] Audit logged (support ticket creation)

## Files
- `hogwarts/features/profile/views/help-center-view.swift`
- `hogwarts/features/profile/views/help-article-view.swift`
- `hogwarts/features/profile/services/support-service.swift`
- `hogwarts/Resources/help-articles/{ar,en}/*.md` — bundled

## API Contract
- `POST /api/mobile/support/ticket` — body `{ subject, body, diagnostics }`

## i18n Keys
- `profile.help.title`, `profile.help.search`, `profile.help.contact`, `profile.help.ticket_sent`

## Tests
- `HogwartsTests/profile/help-center-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: SET-009 (diagnostics bundle)
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
