# SHR-003: LPLinkMetadata Rich Previews

**Epic**: F-SHARING
**Priority**: P1
**Phase**: M1
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As any user, I want shared entity links to render rich previews (title, subtitle, image), so that the recipient sees context before tapping.

## Acceptance Criteria
### AC-1: Metadata provider
**Given** a ShareLink invocation **When** the share sheet builds preview **Then** an LPLinkMetadata is provided synchronously with `title`, `subtitle`, `iconProvider` (school logo), and `imageProvider` (entity image when applicable).

### AC-2: Locale-aware
**Given** the recipient's app language **When** the link is rendered in their preview **Then** title and subtitle pull from the entity's `lang` field; falls back to default app lang.

### AC-3: Universal link domain
**Given** a generated URL **When** rendered in iMessage **Then** the kingfahad.databayt.org universal link domain enables thumbnail.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`)
- [ ] RTL-tested (preview in AR)
- [ ] schoolId scope (icon = current school logo)
- [ ] Entity content rendered with `entity.lang`

## Files
- `hogwarts/core/sharing/link-metadata-provider.swift` — LPLinkMetadata builder
- `hogwarts/core/sharing/share-link-helpers.swift` — wire provider
- `hogwarts/features/announcements/views/announcement-detail-view.swift` — pass entity

## API Contract
None — metadata derived from local entity.

## i18n Keys
- `common.share.preview.title`
- `common.share.preview.subtitle`

## Tests
- `HogwartsTests/sharing/link-metadata-tests.swift`
- Snapshot AR + EN

## Dependencies
- Depends on: SHR-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
