---
code: NOTIF
title: Notifications
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/notifications/*"]
i18n_namespaces: [notifications]
multi_tenant: required
---

# NOTIF — Notifications

## Goal
In-app notifications list, mark-read flows, deep-link to detail, per-channel preferences, quiet hours, channel groups, per-school overrides for multi-tenant users.

## Scope

**In**: List, mark-read, mark-all, detail, preferences, quiet hours, channel groups, per-school override.

**Out**: APNs registration & rich notifications (F-PUSH epic).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| NOTIF-001 | In-app list | 3 | M0 | all |
| NOTIF-002 | Mark read | 1 | M0 | all |
| NOTIF-003 | Mark all read | 1 | M0 | all |
| NOTIF-004 | Detail / deep-link | 2 | M0 | all |
| NOTIF-005 | Preferences (per channel: messages, attendance, grades, fees, announcements) | 5 | M0 | all |
| NOTIF-006 | Quiet hours | 3 | M1 | all |
| NOTIF-007 | Channel groups (subscribe/unsubscribe) | 3 | M1 | all |
| NOTIF-008 | Per-school notification override | 2 | M1 | all |

## Cross-cutting checks
- [ ] Notification body renders in entity content lang (server respects + client overrides)
- [ ] Channel labels localized
- [ ] Quiet hours respect locale (12h/24h)
- [ ] Per-school override prevents cross-tenant noise

## Backend dependencies
- ✅ List + mark-read endpoints — live
- ✅ Preferences endpoint — live

## Definition of Done
- [ ] User toggles a channel off; new notifications in that channel suppressed
- [ ] Quiet hours 22:00–07:00 silences during window
- [ ] Multi-school user disables school B notifications without affecting school A
