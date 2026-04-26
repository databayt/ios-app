# DASH-AC-002: Accountant Collections Quick View

**Epic**: DASHBOARD
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [accountant]
**Multi-Tenant**: required

## User Story
As an accountant, I want a top-5 list of largest outstanding balances with one-tap follow-up, so that I act fast on biggest receivables.

## Acceptance Criteria
### AC-1: Top 5 outstanding
**Given** dashboard loads **When** the list renders **Then** I see the top 5 outstanding balances sorted descending, each with student/family name and amount.

### AC-2: Tap → reminder action
**Given** I tap a row **When** the action sheet appears **Then** I can send a reminder via SMS, WhatsApp, or email; the action is logged.

### AC-3: Cross-cutting
Currency. Names in entity.lang. RTL list. Multi-channel actions disabled if channel unconfigured.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `home`, `finance`, `whatsapp`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated (accountant only)
- [ ] Audit logged (reminder sent)

## Files
- `hogwarts/features/dashboard/views/accountant-collections-list.swift`
- `hogwarts/features/dashboard/viewmodels/accountant-dashboard-viewmodel.swift`
- `hogwarts/features/dashboard/services/collections-service.swift`

## API Contract
- `GET /api/mobile/dashboard/collections/top` → `[{ familyId, name, balance }]`
- `POST /api/mobile/dashboard/collections/:familyId/remind` — body `{ channel }`

## i18n Keys
- `home.acc.top_outstanding`, `home.acc.remind.sms`, `home.acc.remind.whatsapp`, `home.acc.remind.email`, `home.acc.reminder_sent`

## Tests
- `HogwartsTests/dashboard/accountant-collections-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: DASH-AC-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, role-gated, parity preserved
