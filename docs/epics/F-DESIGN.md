---
code: F-DESIGN
title: Design System & Atoms
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: []
i18n_namespaces: [common]
multi_tenant: required
---

# F-DESIGN — Design System & Atoms

## Goal
Complete the iOS-26 / Liquid Glass design system: missing atoms (toast, segmented control, picker, stepper, switch, slider, progress, skeleton, form fields), motion + elevation + haptic tokens, full Dynamic Type pass, Reduce Motion / Reduce Transparency / High Contrast variants, and a state library (skeleton + empty + error). Source of truth for every other epic's UI.

## Scope

**In**: 10+ new atoms, motion tokens, elevation tokens, haptic helpers, Dynamic Type audit, accessibility variant audit, FormField primitives.

**Out**: New screens (consumed by other epics), individual feature polish (handled per-epic).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| DSGN-001 | Atom audit + studio expansion for missing primitives | 5 | M0 | all |
| DSGN-002 | Token completion: motion (AppleAnimation), elevation, haptics, gradients | 3 | M0 | all |
| DSGN-003 | Liquid Glass v2 audit per screen | 5 | M0 | all |
| DSGN-004 | Dynamic Type pass — every text scales 0.85x to 3x | 5 | M0 | all |
| DSGN-005 | Reduce Motion / Reduce Transparency variants | 2 | M0 | all |
| DSGN-006 | High Contrast palette swap | 2 | M0 | all |
| DSGN-007 | Form atoms (InputField, SelectField, DateField, FileField, PhotoField) | 5 | M0 | all |
| DSGN-008 | Skeleton + empty + error state library | 3 | M0 | all |

## Cross-cutting checks
- [ ] All atoms have `@Preview` in light/dark/RTL/Dynamic Type-3x
- [ ] All atoms render correctly under Reduce Motion + Reduce Transparency
- [ ] No hardcoded hex/rgb in atoms — semantic tokens only
- [ ] Atom Studio (`atom-studio.swift`) showcases every primitive
- [ ] Every form atom emits localized error states

## Backend dependencies
None.

## Definition of Done
- [ ] All atoms documented in Atom Studio
- [ ] Snapshot tests cover each atom × {light, dark} × {LTR, RTL} × {Dynamic Type 1x, 3x}
- [ ] Reduce-Motion variants verified
- [ ] Migration applied to existing 19 atoms
