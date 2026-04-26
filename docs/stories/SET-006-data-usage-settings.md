# SET-006: Data Usage Settings

**Epic**: SETTINGS
**Priority**: P0
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: required

## User Story
As a user on metered cellular, I want to control image quality and video preload, so that I can save bandwidth.

## Acceptance Criteria
### AC-1: Cellular toggles
**Given** I am on cellular **When** I disable "Preload videos" **Then** videos require an explicit tap to load.

### AC-2: Image quality on cellular
**Given** Image Quality = Standard on cellular **When** images load **Then** the app fetches `?q=70` variants; on Wi-Fi `?q=92` variants load.

### AC-3: Cross-cutting
Reachability change updates effective limits live. Localized labels. RTL row alignment.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `profile`, `common`)
- [ ] RTL-tested
- [ ] schoolId predicate (n/a)
- [ ] Role-gated (all)
- [ ] Audit logged (n/a)

## Files
- `hogwarts/features/settings/views/data-usage-view.swift`
- `hogwarts/core/network/data-saver-policy.swift`

## API Contract
- (none — local pref drives image URL params)

## i18n Keys
- `profile.data.title`, `profile.data.cellular`, `profile.data.wifi`, `profile.data.image_quality`, `profile.data.video_preload`

## Tests
- `HogwartsTests/settings/data-usage-tests.swift`
- Snapshot AR + EN + light/dark

## Dependencies
- Depends on: SET-001
- Blocks: —

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, parity preserved
