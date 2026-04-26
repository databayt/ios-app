---
code: SUBSTITUTION
title: Substitution Workflow
phase: M2
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P2
backend_dependencies: ["/api/mobile/teacher/absences", "/api/mobile/teacher/substitutions/*"]
i18n_namespaces: [common]
multi_tenant: required
---

# SUBSTITUTION — Substitution Workflow

## Goal
Teacher requests absence; colleagues accept cover; admin approves; affected students/guardians notified. Critical staff-retention feature.

## Scope

**In**: Teacher absence request, substitution accept, admin approval, affected-students notification.

**Out**: Schedule rendering of substitutions (TIMETABLE TT-005).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| SUB-T-001 | Teacher absence request | 3 | M2 | teacher |
| SUB-T-002 | Substitution accept (cover for colleague) | 3 | M2 | teacher |
| SUB-T-003 | Admin approval | 3 | M2 | admin |
| SUB-T-004 | Affected students notification | 2 | M2 | student, guardian |

## Cross-cutting checks
- [ ] Reason field localized
- [ ] Substitute teacher name renders in entity content lang
- [ ] Audit log per state transition
- [ ] Notification body localized to recipient's app lang

## Backend dependencies
- 🔴 Substitution endpoints — P2 backend

## Definition of Done
- [ ] Teacher A requests absence → push to colleagues
- [ ] Teacher B accepts → admin sees pending approval
- [ ] Admin approves → student/guardian notified of substitute
