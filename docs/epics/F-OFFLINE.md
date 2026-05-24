---
code: F-OFFLINE
title: Offline-First Data Layer
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: []
i18n_namespaces: [common, errors]
multi_tenant: required
---

# F-OFFLINE — Offline-First Data Layer

## Goal
Every read works offline. Every write queues with retry. Conflicts resolve gracefully. School switching invalidates caches without data leakage. Background sync fills caches before the user opens the app.

## Scope

**In**: SwiftData schema versioning + migration scaffold v1→v2, PendingAction queue v2 with retry policy, conflict resolution UX (server-wins with local-stash banner), granular per-feature sync banners, offline read coverage tests, tenant-scoped cache invalidation, background sync via BGProcessingTask.

**Out**: Feature-specific offline behavior (handled per-epic with this as the substrate).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| OFF-001 | SwiftData schema versioning + migration plan v1→v2 scaffold | 5 | M0 | all |
| OFF-002 | PendingAction queue v2 with retry policy | 5 | M0 | all |
| OFF-003 | Conflict resolution UX (server-wins with local-stash banner) | 5 | M0 | all |
| OFF-004 | Sync status banner refinements (granular: per-feature) | 3 | M0 | all |
| OFF-005 | Offline read coverage per feature — checklist + tests | 5 | M0 | all |
| OFF-006 | Tenant-scoped cache invalidation on school switch | 3 | M0 | all |
| OFF-007 | Background sync via BGProcessingTask | 3 | M1 | all |

## Cross-cutting checks
- [ ] Every `@Model` has `schoolId` field
- [ ] Every `FetchDescriptor` includes schoolId predicate
- [ ] Cache keys prefixed with school id
- [ ] PendingAction retries with exponential backoff + max attempts
- [ ] Conflicts surface a clear UX, not silent data loss

## Backend dependencies
None — purely client-side.

## Definition of Done
- [ ] App opens fully cached after fresh install + first sync
- [ ] Airplane mode → app still functional for cached data
- [ ] Mutation while offline → queued; reconnect → applied
- [ ] School switch → no school A data visible after switch to school B
