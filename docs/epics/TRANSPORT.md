---
code: TRANSPORT
title: Bus & Transport
phase: M2
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P2
backend_dependencies: ["/api/mobile/transport/*"]
i18n_namespaces: [transportation]
multi_tenant: required
---

# TRANSPORT — Bus & Transport

## Goal
Guardian visibility into child's bus route, live tracking, driver info, pickup/drop alerts. School admins manage routes (web-only initially).

## Scope

**In**: Guardian-side route view, live tracking, driver info, alerts.

**Out**: Admin route management (web-only initially).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| TRP-001 | Child route view | 3 | M2 | guardian |
| TRP-002 | Live bus tracking | 8 | M2 | guardian |
| TRP-003 | Driver info | 2 | M2 | guardian |
| TRP-004 | Pickup/drop alerts | 3 | M2 | guardian |

## Cross-cutting checks
- [ ] Map labels in app language
- [ ] Live tracking respects battery (WebSocket only when active)
- [ ] Driver info localized (name in entity content lang)
- [ ] Alerts geofence-localized

## Backend dependencies
- 🔴 Transport endpoints — P2

## Definition of Done
- [ ] Guardian sees today's route + ETA
- [ ] Live tracking shows bus position with 30s freshness
- [ ] Push alert at pickup + drop-off
