---
code: F-PLATFORM-EXTENDED
title: Watch, Catalyst & Vision
phase: M2
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P2
backend_dependencies: []
i18n_namespaces: [home]
multi_tenant: required
---

# F-PLATFORM-EXTENDED — Apple Platform Extended

## Goal
Apple Watch companion (next class glance, attendance check-in, complications), Mac Catalyst polish (sidebar, keyboard shortcuts, menus), visionOS support deferred to M3+.

## Scope

**In**: Watch app (independent target), Watch complications, Catalyst keyboard shortcuts + menus, sidebar UI for desktop.

**Out**: visionOS (deferred), CarPlay (no use case), iMessage extension (low ROI).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| PLT-X-001 | Apple Watch companion: next class glance | 8 | M2 | student, teacher |
| PLT-X-002 | Apple Watch: attendance check-in | 5 | M2 | teacher |
| PLT-X-003 | Apple Watch complications | 3 | M2 | student, teacher |
| PLT-X-004 | Mac Catalyst polish (sidebar, keyboard shortcuts, menus) | 8 | M2 | all |
| PLT-X-005 | visionOS support | 13 | M3 | defer |

## Cross-cutting checks
- [ ] Watch UI respects RTL
- [ ] Watch sync uses WatchConnectivity, tenant-scoped
- [ ] Catalyst respects per-app language toggle
- [ ] Keyboard shortcuts localized

## Backend dependencies
None.

## Definition of Done
- [ ] Watch shows next class with tap-to-open
- [ ] Catalyst supports ⌘K command palette
- [ ] visionOS scaffolded but not shipped
