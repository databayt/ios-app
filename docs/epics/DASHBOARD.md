---
code: DASHBOARD
title: Role-Aware Dashboard
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/dashboard"]
i18n_namespaces: [home, common]
multi_tenant: required
---

# DASHBOARD — Role-Aware Dashboard

## Goal
One epic, six role tracks. The dashboard is the data-rich landing surface (distinct from HOME's springboard). Server-side `GET /api/mobile/dashboard` returns role-appropriate summary; iOS renders per-role variants.

## Scope

**In**: Per-role dashboard views — Student today summary + GPA, Guardian child summary, Teacher today schedule + pending actions, Admin KPIs, Accountant finance KPIs.

**Out**: Detail screens (covered by feature epics).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| DASH-001 | Generic dashboard scaffold (existing) | — | done | all |
| DASH-002 | Role detection + variant routing (existing) | — | done | all |
| DASH-003 | Sync banner integration (existing) | — | done | all |
| DASH-S-001 | Student today summary | 5 | M0 | student |
| DASH-S-002 | Student attendance + GPA cards | 3 | M0 | student |
| DASH-S-003 | Student upcoming exams + assignments | 3 | M0 | student |
| DASH-G-001 | Guardian child selector + summary | 5 | M0 | guardian |
| DASH-G-002 | Guardian child quick actions (excuse, message teacher) | 3 | M0 | guardian |
| DASH-T-001 | Teacher today schedule | 3 | M0 | teacher |
| DASH-T-002 | Teacher pending grades + attendance | 3 | M0 | teacher |
| DASH-A-001 | Admin school KPIs | 5 | M1 | admin |
| DASH-A-002 | Admin recent activity feed | 3 | M1 | admin |
| DASH-AC-001 | Accountant finance KPIs (collected/outstanding/overdue) | 5 | M1 | accountant |
| DASH-AC-002 | Accountant collections quick view | 3 | M1 | accountant |

## Cross-cutting checks
- [ ] All strings localized
- [ ] Role detection at view entry (guards rendering)
- [ ] Cards work offline (cached)
- [ ] Numbers locale-formatted (Arabic-Indic in ar)
- [ ] Currency uses TenantContext.currency

## Backend dependencies
- ✅ `GET /api/mobile/dashboard` — live; returns role-aware payload

## Definition of Done
- [ ] Each role sees their own variant on login
- [ ] Pull-to-refresh updates all cards
- [ ] Offline mode shows cached + stale banner
- [ ] Card tap navigates to feature detail
