---
code: WELLBEING
title: Health, Discipline & Achievements
phase: M2
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P2
backend_dependencies: ["/api/mobile/wellbeing/*"]
i18n_namespaces: [profile, common]
multi_tenant: required
---

# WELLBEING — Health, Discipline & Achievements

## Goal
Sensitive read-only surfaces gated by role: health record (allergies, conditions, emergency contacts), disciplinary record with appeal action, achievements showcase, counselor messaging.

## Scope

**In**: Health record, discipline (with appeal), achievements, counselor messaging.

**Out**: Profile achievements card (PROFILE PROF-006 separately).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| WB-001 | Health record view (allergies, conditions, emergency contacts) | 5 | M2 | guardian, teacher |
| WB-002 | Disciplinary record (read-only with appeal action) | 5 | M2 | guardian, student |
| WB-003 | Achievements showcase | 3 | M2 | student, guardian |
| WB-004 | Counselor messaging | 5 | M2 | student, guardian |

## Cross-cutting checks
- [ ] Health data tagged sensitive (no screenshot, no clipboard)
- [ ] Disciplinary record renders content in entity lang
- [ ] Counselor messages reuse MESSAGING infrastructure but with privacy flag
- [ ] Permission gates STRICT (teachers see only their classes' health records, etc.)

## Backend dependencies
- 🔴 Wellbeing endpoints — P2 backend

## Definition of Done
- [ ] Guardian views child's health record; allergies highlighted
- [ ] Student views disciplinary record; can submit appeal
- [ ] Counselor message thread separate from regular messaging
- [ ] Health record cannot be screenshot
