---
code: TIMETABLE
title: Schedule & Calendar
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/timetable/:userId", "/api/mobile/teacher/schedule"]
i18n_namespaces: [common]
multi_tenant: required
---

# TIMETABLE — Schedule & Calendar

## Goal
Today / week / day / month views of the user's schedule. Class detail view. Substitution awareness. Add to system Calendar. Academic year + term overlay. Conflict highlighting for teachers.

## Scope

**In**: Today summary, week grid, day list, class detail (subject/teacher/room/students), substitution awareness, EventKit add-to-calendar, year/term overlay, conflict highlights.

**Out**: Substitution workflow (SUBSTITUTION epic), system calendar subscription (F-INTEGRATION INT-006).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| TT-001 | Today view (current+next class) | 3 | M0 | student, teacher |
| TT-002 | Week view (grid, swipeable) | 5 | M0 | student, teacher |
| TT-003 | Day view (vertical list) | 3 | M0 | student, teacher |
| TT-004 | Class detail (subject, teacher, room, students) | 3 | M0 | all |
| TT-005 | Substitution awareness on day/week | 3 | M1 | student, teacher |
| TT-006 | Add to system Calendar | 2 | M0 | student, teacher |
| TT-007 | Academic year + term overlay | 3 | M1 | student |
| TT-008 | Conflict highlight (teacher schedule) | 3 | M1 | teacher |

## Cross-cutting checks
- [ ] Time formats locale-aware (12h/24h)
- [ ] Week starts on day per `School.weekStartsOn`
- [ ] Class names render in entity content language
- [ ] RTL: week grid flips so today/next is leading

## Backend dependencies
- ✅ `GET /api/mobile/timetable/:userId` — live
- 🟡 `GET /api/mobile/teacher/schedule` — verify or P1 ticket

## Definition of Done
- [ ] Tap a class → detail
- [ ] Add a class to Calendar → event in iOS Calendar with correct timezone
- [ ] Week view scrolls smoothly at 120Hz
- [ ] Substitution shown with visible indicator
