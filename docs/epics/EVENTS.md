---
code: EVENTS
title: School Events
phase: M1
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: ["/api/mobile/events/*"]
i18n_namespaces: [common]
multi_tenant: required
---

# EVENTS — School Events

## Goal
Browse upcoming and past events, view detail with venue + RSVP, calendar view, add to system Calendar, share. Admins author events.

## Scope

**In**: Reader stories (list, detail, calendar, register, add to calendar, share) + admin author.

**Out**: Transport details for events (TRANSPORT epic).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| EVT-001 | List (by date, type) | 3 | M1 | all |
| EVT-002 | Detail (description, venue, RSVP) | 3 | M1 | all |
| EVT-003 | Calendar view | 5 | M1 | all |
| EVT-004 | Register / RSVP | 3 | M1 | guardian, student |
| EVT-005 | Add to system Calendar | 1 | M1 | all |
| EVT-006 | Share | 1 | M1 | all |
| EVT-T-001 | Create event | 5 | M2 | admin |

## Cross-cutting checks
- [ ] Event title/desc render in entity content lang
- [ ] Date/time locale-formatted, school timezone-aware
- [ ] Calendar grid RTL-aware
- [ ] RSVP audit-logged with `school_id`

## Backend dependencies
- ✅ `GET /events`, `:id`, `POST /events/:id/register` — live

## Definition of Done
- [ ] User RSVPs → server records → server-side capacity decremented
- [ ] Tap "Add to Calendar" → iOS Calendar entry with correct timezone
- [ ] Calendar view scrolls past 12 months smoothly
