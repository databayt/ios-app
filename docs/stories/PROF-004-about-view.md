# PROF-004: About View

**Epic**: PROFILE
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user, I want to see app version, build, and credits, so that I can identify the build when reporting issues.

## Acceptance Criteria
### AC-1: Shows version + build
**Given** I open About **When** the view loads **Then** I see version (CFBundleShortVersionString), build (CFBundleVersion), commit SHA, and a credits link.

### AC-2: Tap version 7× → diagnostics
**Given** developer-mode hidden gesture **When** I tap version 7 times **Then** a diagnostics panel reveals.

### AC-3: Cross-cutting
All copy localized. RTL-aware list layout. No PII shown.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (n/a — static)
- [ ] Role-gated (n/a)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/profile/views/about-view.swift`
- `hogwarts/core/build-info/build-info.swift`

## API Contract
- (none — static content + bundled credits)

## i18n Keys
- `profile.about.title`, `profile.about.version`, `profile.about.build`, `profile.about.credits`, `profile.about.licenses`

## Tests
- `HogwartsTests/profile/about-view-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: —
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, parity preserved
