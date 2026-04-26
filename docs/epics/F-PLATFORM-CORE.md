---
code: F-PLATFORM-CORE
title: Widgets, Live Activities & iPad
phase: M1
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: []
i18n_namespaces: [home]
multi_tenant: required
---

# F-PLATFORM-CORE — Apple Platform Core

## Goal
Lock Screen + Home Screen widgets with role awareness, Live Activities for class-in-session and exam timer, iPad NavigationSplitView, StandBy mode styling, interactive widget for one-tap attendance.

## Scope

**In**: Small/medium/large home widgets (next class, today's schedule), Lock Screen widgets (attendance status, unread messages), Live Activities (class timer, exam timer, hall pass active), iPad sidebar layout, StandBy widget styling, interactive widget for mark attendance.

**Out**: Watch + Catalyst + Vision (handled in F-PLATFORM-EXTENDED).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| PLT-001 | Small home widget: next class | 5 | M1 | student, teacher |
| PLT-002 | Medium widget: today's schedule | 5 | M1 | student, teacher |
| PLT-003 | Lock Screen widget: attendance status | 3 | M1 | student, guardian |
| PLT-004 | Lock Screen widget: unread messages count | 3 | M1 | all |
| PLT-005 | Live Activity: class in session timer | 5 | M1 | student, teacher |
| PLT-006 | Live Activity: exam timer | 5 | M2 | student |
| PLT-007 | Live Activity: hall pass active | 3 | M2 | student, teacher |
| PLT-008 | StandBy mode widget styling | 2 | M1 | all |
| PLT-009 | Interactive widget (mark attendance) | 8 | M2 | teacher |
| PLT-010 | iPad layouts via NavigationSplitView | 8 | M1 | all |

## Cross-cutting checks
- [ ] Widget content respects RTL
- [ ] Widget timeline includes tenant context (no cross-school leak)
- [ ] Live Activity respects entity content language
- [ ] iPad layouts pass orientation rotation
- [ ] StandBy uses high-contrast typography

## Backend dependencies
None — widgets read from local SwiftData cache.

## Definition of Done
- [ ] Widget on Lock Screen shows correct next class for student
- [ ] Live Activity counts down class duration accurately
- [ ] iPad split view shows list + detail correctly in landscape
- [ ] Interactive widget mark-attendance updates server within 5s
