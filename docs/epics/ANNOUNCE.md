---
code: ANNOUNCE
title: Announcements
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/announcements/*"]
i18n_namespaces: [messages]
multi_tenant: required
---

# ANNOUNCE — Announcements

## Goal
Announcement feed (Important + Recent sections), detail with rich content, read receipts, share, deep-links from notifications, important banner overlay for P0. Admin/teacher authoring with content language picker, scheduling, audience targeting, templates.

## Scope

**In**: Reader stories + author stories.

**Out**: Notification preferences (NOTIF), governance/consent (GOV).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| ANN-001 | Feed (Important + Recent sections) | 3 | M0 | all |
| ANN-002 | Detail view (with rich content rendering, per-message lang) | 3 | M0 | all |
| ANN-003 | Read receipts | 2 | M0 | all |
| ANN-004 | Share | 2 | M0 | all |
| ANN-005 | Deep-link from notification | 2 | M0 | all |
| ANN-006 | Important banner overlay (P0 announcements) | 3 | M0 | all |
| ANN-T-001 | Author announcement (with content language picker) | 5 | M1 | admin, teacher |
| ANN-T-002 | Schedule announcement | 3 | M2 | admin |
| ANN-T-003 | Target audience (role/class/grade) | 5 | M1 | admin |
| ANN-T-004 | Templates | 3 | M2 | admin |

## Cross-cutting checks
- [ ] Each announcement rendered with `announcement.lang` font + direction
- [ ] Translate affordance when content lang ≠ app lang
- [ ] Important banner localized
- [ ] Author chooses content language at composition
- [ ] Audience targeting respects multi-tenancy

## Backend dependencies
- ✅ `GET /announcements`, `:id` — live
- 🟡 Author/schedule/target endpoints — verify

## Definition of Done
- [ ] Feed shows Important + Recent sections
- [ ] P0 announcement triggers banner overlay even if app open
- [ ] Author posts Arabic announcement; English-app guardian sees translate option
- [ ] Targeting class-only announcement only goes to that class
