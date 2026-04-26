# SHR-001: ShareLink for Entities

**Epic**: F-SHARING
**Priority**: P1
**Phase**: M0
**Status**: pending
**Effort**: XS
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want to share announcements, events, and assignments via the iOS share sheet, so that I can pass links to family/colleagues in their preferred app.

## Acceptance Criteria
### AC-1: ShareLink presence
**Given** a detail screen for announcement/event/assignment **When** rendered **Then** a SwiftUI ShareLink is present in toolbar with title and URL.

### AC-2: Universal link payload
**Given** user shares an announcement **When** the recipient taps the link **Then** the app opens to the announcement detail (handled via Universal Links).

### AC-3: Tenant scope
**Given** the URL is generated **When** sent **Then** it includes `school_id` and entity ID; opening it on a device signed into a different school routes to disambiguation.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested
- [ ] schoolId scope (URL embeds tenant)
- [ ] Role-gated (only entities user can read are shareable)

## Files
- `hogwarts/core/sharing/share-link-helpers.swift` — URL builders
- `hogwarts/features/announcements/views/announcement-detail-view.swift` — toolbar
- `hogwarts/features/events/views/event-detail-view.swift` — toolbar
- `hogwarts/features/assignments/views/assignment-detail-view.swift` — toolbar

## API Contract
None — URLs are deterministic from entity IDs.

## i18n Keys
- `common.share.title`
- `common.share.subject`

## Tests
- `HogwartsTests/sharing/share-link-tests.swift`
- Snapshot AR + EN, light + dark

## Dependencies
- Depends on: AUTH-014 (Universal Links)
- Blocks: SHR-003, SHR-004

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
