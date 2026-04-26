---
code: F-CORE
title: Core Infrastructure
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/auth (PUT)", "/api/mobile/profile"]
i18n_namespaces: [common, errors]
multi_tenant: required
---

# F-CORE — Core Infrastructure

## Goal
Lay the foundation every other epic stands on: hardened API client, race-safe token refresh, multi-tenant context, audit logging, feature flags, telemetry, environment configuration, certificate pinning, and background refresh. Without F-CORE, no module can ship safely.

## Scope

**In**: APIClient migration to `/api/mobile/*`, snake_case decoding, JWT decode helpers, TenantContext, AuditLog client writer, feature flag store, Sentry integration, env schemes, cert pinning, BGAppRefreshTask.

**Out**: Sync engine v2 (F-OFFLINE), push registration (F-PUSH), media plumbing (F-MEDIA), intents wiring (F-INTENTS).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| CORE-001 | Migrate APIClient to /api/mobile/* prefix and snake_case decoding | 3 | M0 | all |
| CORE-002 | Token refresh via PUT /mobile/auth with X-Refresh-Token; transparent 401 retry | 5 | M0 | all |
| CORE-003 | Remove mock login bypass from auth-manager.swift | 1 | M0 | all |
| CORE-004 | JWT decode helper extracts schoolId/role/exp client-side | 2 | M0 | all |
| CORE-005 | TenantContext observable with currentSchoolId/Role/SchoolName/currency | 3 | M0 | all |
| CORE-006 | core/audit/audit-log.swift writes mutation events to backend AuditLog | 3 | M0 | all |
| CORE-007 | Feature flags (@AppStorage-backed) for ramping risky stories | 2 | M0 | all |
| CORE-008 | Telemetry sink (Sentry SDK + custom events) | 3 | M0 | all |
| CORE-009 | Env config (debug/staging/prod) wired into project.yml schemes | 2 | M0 | all |
| CORE-010 | Certificate pinning via URLSessionDelegate | 5 | M1 | all |
| CORE-011 | Background refresh (BGAppRefreshTask) for sync | 3 | M1 | all |

## Cross-cutting checks
- [ ] All endpoints use `/api/mobile/*` prefix
- [ ] Snake_case decoding strategy globally on APIClient
- [ ] TenantContext is the single source for `schoolId` at runtime
- [ ] Token refresh is race-safe (single in-flight refresh, request queueing)
- [ ] AuditLog writes for every mutation
- [ ] Sentry traces tagged with `tenant_id`, `role`, `app_locale`

## Backend dependencies
- ✅ `PUT /api/mobile/auth` (refresh) — live
- ✅ `GET /api/mobile/profile` — live
- 🔴 AuditLog endpoint for client mutations (verify exists or file ticket)

## Definition of Done
- [ ] All stories merged
- [ ] No legacy non-`/mobile/` endpoint calls remain
- [ ] Snapshot of fresh login → action → background → resume passes
- [ ] Sentry receives events from staging build
- [ ] CI green: i18n + tenant gates
