# LOC-005: Locale Formatters Bound to Per-Tenant Currency

**Epic**: F-LOCALE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** parent or accountant
**I want** money displayed in my school's currency (SDG, SAR, USD)
**So that** invoices and balances reflect the school's actual billing, not my device locale

## Acceptance Criteria

### AC-1: Currency from TenantContext
**Given** an amount **When** formatted via `Money.format(_:)` **Then** the currency code comes from `TenantContext.shared.currency`, never `Locale.current.currency`.

### AC-2: Date / number / measurement formatters
**Given** dates, numbers, or measurements **When** formatted **Then** locale-aware FormatStyle is used; numerals follow the app locale (Arabic-Indic for ar).

### AC-3: Switch updates
**Given** the user switches school **When** `currency` changes **Then** open screens re-render with the new currency.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `finance`)
- [ ] schoolId predicate (currency tied to tenant)

## Files
- `hogwarts/core/format/money.swift`
- `hogwarts/core/format/dates.swift`
- `hogwarts/core/format/numbers.swift`
- `hogwarts/core/format/measurement.swift`

## API Contract
- Reads `currency` from `GET /api/mobile/profile` school object.

## i18n Keys
- None (formatters; downstream features use them with their own keys).

## Tests
- `HogwartsTests/core/format/format-tests.swift` — SDG/SAR/USD school × ar/en locale

## Dependencies
- Depends on: CORE-005, LOC-004
- Blocks: every finance/invoice feature

## Definition of Done
- [ ] AC met, no `Locale.current.currency` references remain, snapshot AR + EN
