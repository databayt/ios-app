# LOC-004: Per-App Language Toggle — Zero Restart

**Epic**: F-LOCALE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
**As a** user
**I want** to switch app language between Arabic and English from Settings without restarting
**So that** my UI flips immediately

## Acceptance Criteria

### AC-1: Toggle UX
**Given** Settings → Language **When** I tap the segmented control **Then** the app updates `@AppStorage("selectedLanguage")` and re-renders all screens in the chosen locale within 1 frame.

### AC-2: RTL flips automatically
**Given** I switch en → ar **When** the change applies **Then** the layout direction flips to RTL with no white screens or restart prompts.

### AC-3: Persisted across launches
**Given** I close and relaunch **When** the app boots **Then** the chosen language persists.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `common`)
- [ ] RTL-tested both directions
- [ ] schoolId predicate (TenantContext default language overridden by user choice)

## Files
- `hogwarts/features/settings/views/language-toggle-view.swift`
- `hogwarts/HogwartsApp.swift` — already wires `@AppStorage("selectedLanguage")`; refine to publish `LayoutDirection` change synchronously

## API Contract
- None.

## i18n Keys
- `profile.language.title`, `profile.language.arabic`, `profile.language.english`

## Tests
- `HogwartsTests/locale/language-toggle-tests.swift` — toggle, persistence, layout direction observable

## Dependencies
- Depends on: LOC-001
- Blocks: LOC-008

## Definition of Done
- [ ] AC met, RTL screenshot ar + en, no restart prompt, persistence verified
