# GRD-007: Communication preferences (per teacher)

**Epic**: GUARDIAN-LINK
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [guardian]
**Multi-Tenant**: required

## User Story
**As a** guardian
**I want** per-teacher communication preferences
**So that** I control how each teacher reaches me

## Acceptance Criteria

### AC-1: List teachers
**Given** Settings → Communication **When** opened **Then** child's teachers listed with preferred channel toggles (in-app, email, SMS, WhatsApp).

### AC-2: Update
**Given** I change a toggle **When** saved **Then** future routing respects preference; immediate confirmation.

### AC-3: Cross-cutting
**Given** preferences mutation **When** sent **Then** `school_id` + `child_id` + `teacher_id` enforced; audit logged.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `common`)
- [ ] RTL-tested
- [ ] schoolId on PATCH
- [ ] Audit logged
- [ ] Role gate (guardian only)
- [ ] Entity content lang for teacher names

## Files
- `hogwarts/features/guardian/views/communication-preferences-view.swift`
- `hogwarts/features/guardian/viewmodels/communication-preferences-viewmodel.swift`
- `hogwarts/features/guardian/services/guardian-actions.swift`

## API Contract
- `GET /api/mobile/guardian/communication-preferences?child_id=...` — `[ { teacher_id, name, lang, channels:{in_app,email,sms,whatsapp} } ]`
- `PATCH /api/mobile/guardian/communication-preferences/:teacher_id` — partial update

## i18n Keys
- `profile.comm_prefs.title`
- `profile.comm_prefs.channel.in_app`
- `profile.comm_prefs.channel.email`
- `profile.comm_prefs.channel.sms`
- `profile.comm_prefs.channel.whatsapp`

## Tests
- `HogwartsTests/guardian/communication-preferences-tests.swift`

## Dependencies
- Depends on: GRD-001, GRD-002
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, audit row exists
