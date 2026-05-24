---
code: ATTENDANCE
title: Attendance
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/attendance/*"]
i18n_namespaces: [attendance]
multi_tenant: required
---

# ATTENDANCE — Attendance

## Goal
Two tracks: student/guardian read-only history + summary + gamification, and teacher mark-attendance flows (single, bulk, QR, NFC, beacon, kiosk) plus excuses, hall passes, interventions, analytics.

## Scope

**In**: All ATT-* (student) and ATT-T-* (teacher) stories below. Each method (QR/NFC/beacon/kiosk) is its own story.

**Out**: Substitution (SUBSTITUTION epic), wellbeing impact (WELLBEING epic).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| ATT-001 | Student history list | 3 | M0 | student, guardian |
| ATT-002 | Summary card (% present, by subject) | 3 | M0 | student, guardian |
| ATT-003 | Streaks view | 3 | M1 | student |
| ATT-004 | Badges shelf (gamification) | 5 | M1 | student |
| ATT-005 | Charts (week/month/term) | 5 | M1 | student, guardian |
| ATT-006 | Excuse submit (form + photo of doctor's note) | 5 | M1 | guardian |
| ATT-007 | Absence intention (planned absence) | 3 | M1 | guardian |
| ATT-008 | Hall pass request | 3 | M1 | student |
| ATT-T-001 | Teacher mark single (per student) | 3 | M1 | teacher |
| ATT-T-002 | Teacher bulk mark (whole class) | 5 | M1 | teacher |
| ATT-T-003 | QR code scan attendance | 5 | M1 | teacher |
| ATT-T-004 | NFC tap attendance | 5 | M2 | teacher |
| ATT-T-005 | Bluetooth beacon proximity | 8 | M2 | teacher |
| ATT-T-006 | Kiosk mode (single-class, locked screen) | 5 | M2 | teacher, admin |
| ATT-T-007 | Hall pass issue + end | 3 | M1 | teacher |
| ATT-T-008 | Excuse review (approve/reject) | 3 | M1 | teacher |
| ATT-T-009 | Interventions list (chronic absentees) | 3 | M2 | teacher, admin |
| ATT-T-010 | Analytics dashboard | 5 | M2 | admin |

## Cross-cutting checks
- [ ] Status labels localized (Present, Absent, Late, Excused)
- [ ] Charts: locale numeric formatting
- [ ] Bulk mark UX RTL-aware (drag direction)
- [ ] Offline mark queues; reconnect → applies
- [ ] Permission gates: student/guardian read-only; teacher mark; admin override

## Backend dependencies
- ✅ Read endpoints — live
- 🔴 `POST /api/mobile/teacher/classes/:id/attendance` — P1 backend
- 🔴 `POST /api/mobile/attendance/mark` (single) — verify
- ✅ `POST /api/mobile/attendance/bulk`, `/qr/scan` — live

## Definition of Done
- [ ] Student sees own history offline
- [ ] Teacher marks bulk attendance offline → queues → applies
- [ ] QR scan from camera → attendance recorded in <2s
- [ ] Excuse flow with doctor's note photo persists across reconnect
