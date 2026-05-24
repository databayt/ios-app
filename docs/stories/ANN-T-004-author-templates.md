# ANN-T-004: Templates

**Epic**: ANNOUNCE
**Priority**: P0
**Phase**: M2
**Status**: pending
**Effort**: S
**Roles**: [admin]
**Multi-Tenant**: required

## User Story
**As an** admin
**I want** templates for common announcements (closure, exam, holiday)
**So that** I can compose faster with consistent tone

## Acceptance Criteria

### AC-1: Pick template
**Given** composer **When** I tap "Templates" **Then** a sheet lists per-school templates with EN+AR variants.

### AC-2: Use template
**Given** I tap a template **When** applied **Then** title + body prefilled, audience suggested, lang preselected from template default.

### AC-3: Cross-cutting
**Given** template is owned by school **When** other school admin queries **Then** templates are not visible (multi-tenant).

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `messages`)
- [ ] RTL-tested
- [ ] schoolId on template fetch
- [ ] Role gate (admin only)
- [ ] Template body stored with `lang`

## Files
- `hogwarts/features/announcements/views/templates-sheet-view.swift`
- `hogwarts/features/announcements/viewmodels/templates-viewmodel.swift`
- `hogwarts/features/announcements/models/template-model.swift` — `@Model` with `schoolId`, `lang`

## API Contract
- `GET /api/mobile/announcements/templates` — `[ { id, name, body, lang, default_audience } ]`

## i18n Keys
- `messages.templates.title`
- `messages.templates.use`
- `messages.templates.empty`

## Tests
- `HogwartsTests/announcements/templates-tests.swift`
- Multi-tenant isolation test

## Dependencies
- Depends on: ANN-T-001, ANN-T-003
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified
