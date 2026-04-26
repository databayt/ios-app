---
code: F-PUSH
title: Push Notifications
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/notifications/register"]
i18n_namespaces: [notifications]
multi_tenant: required
---

# F-PUSH — Push Notifications

## Goal
APNs registration, race-safe token refresh, deep-link routing, rich notifications, silent push for sync triggers, notification categories with Quick Actions (Reply, Mark Read), and provisional auth for unobtrusive onboarding. Push is the heartbeat of a school app — if it's broken, parents uninstall.

## Scope

**In**: APNs setup, token send, refresh on foreground, categories with actions, deep-link routing extending `NotificationNavigationState`, silent push for sync, rich (image) notifications via Service Extension, provisional auth.

**Out**: Notification preferences UI (NOTIF epic), per-channel preferences (NOTIF), in-app notification list (NOTIF).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| PUSH-001 | APNs registration + token send via POST /mobile/notifications/register | 3 | M0 | all |
| PUSH-002 | Token refresh on app foreground | 2 | M0 | all |
| PUSH-003 | Notification categories + actions (Reply, Mark Read, View, Dismiss) | 5 | M0 | all |
| PUSH-004 | Deep-link routing from notification (NotificationNavigationState extension) | 5 | M0 | all |
| PUSH-005 | Silent push handling for sync triggers | 3 | M0 | all |
| PUSH-006 | Rich notifications (image, mutable content service extension) | 3 | M1 | all |
| PUSH-007 | Provisional auth for non-disruptive onboarding | 2 | M1 | all |
| PUSH-008 | Notification Service Extension for end-to-end-encrypted message previews | 5 | M2 | all |

## Cross-cutting checks
- [ ] APNs token tagged with `tenant_id` and `device_id` server-side
- [ ] Notification body localized at composition (server respects user.locale + entity.lang)
- [ ] Deep links include `school_id` for tenant verification
- [ ] Quick Actions localized
- [ ] Silent pushes don't show UI but trigger sync engine

## Backend dependencies
- ✅ `POST /api/mobile/notifications/register` — live
- ✅ `POST /api/mobile/notifications/:id/read` — live
- 🟡 Notification Service Extension content backend signing — verify

## Definition of Done
- [ ] Real-device test: announcement push opens detail screen
- [ ] Real-device test: message push Quick Reply works
- [ ] Token refresh after backgrounding 24h
- [ ] Provisional auth onboarding works without prompt
