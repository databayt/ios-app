# DSGN-003: Liquid Glass v2 Audit Per Screen

**Epic**: F-DESIGN
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: not-applicable

## User Story
**As a** designer
**I want** every screen audited against Liquid Glass v2 spec
**So that** translucency, blur radius, and material thickness are consistent app-wide

## Acceptance Criteria

### AC-1: Per-screen checklist
**Given** every existing screen **When** audited **Then** a row in `docs/audits/liquid-glass-v2.md` records: blur material, vibrancy, elevation, fixes needed.

### AC-2: Reduce Transparency variant
**Given** Reduce Transparency is enabled **When** a glass surface renders **Then** it falls back to a solid token (`Color.surface.elevated`).

### AC-3: Fix tickets filed
**Given** a screen fails the audit **When** documented **Then** a follow-up story is filed in the owning feature epic.

## Cross-Cutting Invariants
- [ ] Reduce-Transparency variant present
- [ ] No hardcoded blur radii — token-driven

## Files
- `docs/audits/liquid-glass-v2.md` — audit table
- `hogwarts/design/materials/glass.swift` — central material tokens

## API Contract
- None.

## i18n Keys
- None.

## Tests
- Visual: snapshot per audited screen × {standard, reduceTransparency}

## Dependencies
- Depends on: DSGN-002
- Blocks: DSGN-005

## Definition of Done
- [ ] AC met, audit doc complete, every glass surface uses tokens, follow-up tickets filed
