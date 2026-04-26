---
code: F-INTEGRATION
title: OS-Level Integration
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: []
i18n_namespaces: [common]
multi_tenant: required
---

# F-INTEGRATION — OS-Level Integration

## Goal
Integrate first-class iOS system services so students/parents/teachers don't have to context-switch out of the app's data flow: EventKit (Calendar), Reminders, Photos, Files, Contacts, two-way Calendar subscription.

## Scope

**In**: EventKit add-to-calendar for timetable/exams/events, Reminders for assignment due dates, Contacts read for school directory, Files browser for assignment uploads, Photos integration for avatars, calendar subscription for timetable.

**Out**: Specific use-case wiring (handled per-feature; this epic provides the substrate).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| INT-001 | EventKit add-to-calendar (timetable, exams, events) | 3 | M0 | student, guardian |
| INT-002 | Reminders for assignment due dates | 3 | M1 | student, guardian |
| INT-003 | Contacts integration (school directory) | 5 | M1 | all |
| INT-004 | Files app integration (Document Browser for assignment uploads) | 3 | M1 | student, teacher |
| INT-005 | Photos library (avatar, profile, attachments) | 2 | M0 | all |
| INT-006 | System Calendar two-way sync (timetable subscription) | 5 | M2 | student, teacher |

## Cross-cutting checks
- [ ] Permission rationale strings localized
- [ ] Calendar event titles render in entity content language
- [ ] Reminders include `school_name` for tenant clarity
- [ ] Contacts written carry tenant prefix in identifier

## Backend dependencies
- 🟡 ICS feed for timetable subscription (P2 backend ticket)

## Definition of Done
- [ ] Tap "Add to Calendar" on a class → event appears in iOS Calendar
- [ ] Reminder fires for assignment due date 24h before
- [ ] Contacts permission flow respects denial gracefully
