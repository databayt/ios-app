---
code: Q-A11Y
title: Accessibility
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: []
i18n_namespaces: []
multi_tenant: required
---

# Q-A11Y — Accessibility

## Goal
Full VoiceOver, Dynamic Type, Reduce Motion, Reduce Transparency, High Contrast, keyboard, Voice Control compliance. Localized accessibility labels (not English-only).

## Scope

**In**: VoiceOver pass per critical screen, Dynamic Type, motion/transparency variants, high contrast, keyboard nav for iPad, localized alt text everywhere, Voice Control.

**Out**: Atom-level accessibility (handled in F-DESIGN).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| A11Y-001 | VoiceOver pass per critical screen (auth, home, dashboard, attendance, grades, messages) | 8 | M0 | all |
| A11Y-002 | Dynamic Type pass | 5 | M0 | all |
| A11Y-003 | Reduce Motion variants | 2 | M0 | all |
| A11Y-004 | Reduce Transparency variants | 2 | M0 | all |
| A11Y-005 | High Contrast | 2 | M0 | all |
| A11Y-006 | Keyboard navigation (iPad) | 5 | M1 | all |
| A11Y-007 | Localized alt text on every image | 3 | M0 | all |
| A11Y-008 | Voice Control verification | 3 | M1 | all |

## Cross-cutting checks
- [ ] All accessibility labels are localized strings, not English-only
- [ ] Hit targets ≥44pt
- [ ] Heading levels logical
- [ ] Custom controls expose proper traits (button, header, image)
- [ ] Reduce Motion respected (no implicit animations on key surfaces)

## Backend dependencies
None.

## Definition of Done
- [ ] VoiceOver navigates all M0 screens without dead-ends
- [ ] Dynamic Type 3x renders without truncation
- [ ] Reduce Motion ON → no parallax/spring effects
- [ ] iPad keyboard: tab through forms, Enter to submit
