# SHIP-007: App Review Submission + Appeal Playbook

**Epic**: SHIP
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S (3)
**Roles**: [all]
**Multi-Tenant**: required

## User Story
**As a** publisher
**I want** to submit to App Review with a documented appeal playbook
**So that** the app passes on first attempt and we recover quickly if rejected

## Acceptance Criteria

### AC-1: Reviewer instructions
**Given** the submission
**When** "Notes for Review" is filled
**Then** test credentials, screen-by-screen guide, and notes about COPPA/GDPR-K appear

### AC-2: GOV evidence linked
**Given** reviewer asks about consent / data export / account deletion
**When** the playbook is followed
**Then** GOV-001..GOV-006 stories are linked as evidence

### AC-3: Appeal playbook
**Given** a rejection
**When** the playbook is followed
**Then** documented steps include: parse rejection, fix, resubmit, escalate

## Cross-Cutting Invariants
- [ ] App Store BLOCKER (final gate)

## Files
- `docs/release/app-review-playbook.md`

## API Contract
- (App Store Connect)

## i18n Keys
- (none)

## Tests
- Manual: dry-run submission rehearsal

## Dependencies
- Depends on: GOV-001..GOV-006, SHIP-001..SHIP-006
- Blocks: SHIP-008

## Definition of Done
- [ ] AC met, dry-run completed, evidence links live
