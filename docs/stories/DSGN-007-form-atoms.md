# DSGN-007: Form Atoms — InputField, SelectField, DateField, FileField, PhotoField

**Epic**: F-DESIGN
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: not-applicable

## User Story
**As a** developer building any form
**I want** five canonical form-field atoms with localized error states
**So that** every form has consistent validation UX, RTL behavior, and accessibility

## Acceptance Criteria

### AC-1: Five fields ship
**Given** a feature builds a form **When** it imports `HWInputField`, `HWSelectField`, `HWDateField`, `HWFileField`, `HWPhotoField` **Then** each accepts `label`, `placeholder`, `error: LocalizedStringResource?` and renders identically across forms.

### AC-2: Validation surface
**Given** a field has an error **When** it transitions to error state **Then** the localized message appears below the field with a destructive-tinted border and VoiceOver announces the error.

### AC-3: RTL-aware
**Given** Arabic locale **When** any field renders **Then** label, placeholder, and clear button align to leading (right) automatically.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`, `errors`)
- [ ] RTL-tested
- [ ] Error labels read by VoiceOver

## Files
- `hogwarts/atoms/forms/hw-input-field.swift`
- `hogwarts/atoms/forms/hw-select-field.swift`
- `hogwarts/atoms/forms/hw-date-field.swift`
- `hogwarts/atoms/forms/hw-file-field.swift`
- `hogwarts/atoms/forms/hw-photo-field.swift`

## API Contract
- None (UI only; FileField/PhotoField use MED-001/MED-003 internally).

## i18n Keys
- `common.form.required`, `common.form.optional`, `common.form.clear`, `errors.form.invalid`

## Tests
- `HogwartsTests/atoms/forms/form-atoms-tests.swift` — snapshot AR + EN, error-state, VoiceOver labels

## Dependencies
- Depends on: DSGN-001, MED-001, MED-003
- Blocks: every form-bearing feature

## Definition of Done
- [ ] AC met, snapshot matrix green, VoiceOver labels verified
