# DSGN-001: Atom Studio Expansion — Missing Primitives

**Epic**: F-DESIGN
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: M
**Roles**: [admin, teacher, student, guardian, accountant, staff, user]
**Multi-Tenant**: not-applicable

## User Story
**As a** developer building any feature
**I want** the missing atom primitives (toast, segmented control, picker, stepper, switch, slider, progress, skeleton)
**So that** I never reinvent a control and Atom Studio is the single visual reference

## Acceptance Criteria

### AC-1: Eight new atoms ship
**Given** a feature **When** it needs a primitive **Then** `HWToast`, `HWSegmentedControl`, `HWPicker`, `HWStepper`, `HWSwitch`, `HWSlider`, `HWProgress`, `HWSkeleton` exist with `@Preview` light/dark/RTL/Dynamic Type-3x.

### AC-2: Studio showcases
**Given** Atom Studio (`atom-studio.swift`) opens **When** scrolled **Then** every new primitive renders with example states.

### AC-3: Tokenized
**Given** any new atom **When** inspected **Then** no hardcoded hex/rgb is present; semantic tokens only.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `common`) — for placeholder labels
- [ ] RTL-tested (Studio Preview)

## Files
- `hogwarts/atoms/hw-toast.swift`, `hw-segmented-control.swift`, `hw-picker.swift`, `hw-stepper.swift`, `hw-switch.swift`, `hw-slider.swift`, `hw-progress.swift`, `hw-skeleton.swift`
- `hogwarts/atoms/atom-studio.swift` — register new atoms

## API Contract
- None.

## i18n Keys
- `common.atom.toast.example`, `common.atom.picker.placeholder`

## Tests
- `HogwartsTests/atoms/atom-snapshot-tests.swift` — snapshot per atom × {light,dark} × {LTR,RTL} × {DT 1x,3x}

## Dependencies
- Depends on: DSGN-002 (motion + haptic tokens consumed)
- Blocks: DSGN-007, every feature epic

## Definition of Done
- [ ] AC met, snapshot matrix green, no hex literals, Atom Studio updated
