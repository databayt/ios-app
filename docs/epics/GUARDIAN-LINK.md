---
code: GUARDIAN-LINK
title: Guardian Multi-Child Linkage
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/guardian/*"]
i18n_namespaces: [profile, common]
multi_tenant: required
---

# GUARDIAN-LINK — Guardian Multi-Child Linkage

## Goal
Guardians link to one or more children (potentially across schools). The selected child becomes the "active context" for child-scoped views (attendance, grades, fees, timetable). Guardian-specific actions: meeting booking, consent forms, trip permissions, communication preferences.

## Scope

**In**: Children list, child selector (global app context), child profile detail, meeting booking, consent forms, trip permissions, communication preferences.

**Out**: Per-child read views (covered by ATTENDANCE/GRADES/FEES/TIMETABLE with child filter).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| GRD-001 | Children list | 3 | M0 | guardian |
| GRD-002 | Child selector (global app context) | 5 | M0 | guardian |
| GRD-003 | Child profile detail | 3 | M0 | guardian |
| GRD-004 | Meeting booking with teacher | 5 | M2 | guardian |
| GRD-005 | Consent forms (sign + history) | 5 | M1 | guardian |
| GRD-006 | Trip permission slips | 5 | M2 | guardian |
| GRD-007 | Communication preferences (per teacher) | 3 | M2 | guardian |

## Cross-cutting checks
- [ ] Selected child changes app context — caches keyed by child
- [ ] Multi-school guardians: child selector shows school per child
- [ ] Consent forms render with `form.lang`
- [ ] All guardian endpoints filter by `guardian_id` + `school_id`

## Backend dependencies
- ✅ `GET /guardian/children`, `:childId/{attendance,grades,fees,timetable}` — live
- 🔴 Consent + meeting + trip endpoints — P1/P2

## Definition of Done
- [ ] Guardian sees all children, can switch active child
- [ ] Active child reflects in attendance/grades/fees/timetable views
- [ ] Sign consent form → recorded with timestamp + device
- [ ] Multi-school guardian sees correct school per child
