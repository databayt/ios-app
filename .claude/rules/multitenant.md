---
paths: ["hogwarts/**/*.swift"]
description: schoolId scoping invariants for queries, caches, and mutations
---

# Multi-Tenancy Rule

When writing or editing data layer code (services, view-models, models, caches):

## Required on every data path

- ✅ Every `@Model` declares `var schoolId: String`
- ✅ Every `FetchDescriptor<T>` includes `#Predicate { $0.schoolId == schoolId }`
- ✅ Every ViewModel reads `TenantContext.shared.currentSchoolId`, never view-arg
- ✅ Every cache key prefixed with `<schoolId>:`
- ✅ Every mutation logs `AuditEvent(tenantId: schoolId, ...)` to `core/audit/audit-log.swift`
- ✅ Verify response payload `school_id` matches `TenantContext` (defense in depth)

## Forbidden

- ❌ `FetchDescriptor` without `schoolId` predicate
- ❌ Hardcoded `schoolId: "..."` in queries (must come from TenantContext)
- ❌ Storing tokens or user data in `UserDefaults` — use Keychain via `core/auth/keychain-service.swift`
- ❌ Cross-tenant lookups (joining tables without schoolId)

## When the user switches schools

- Invalidate image caches, document caches, search index
- Clear in-memory state of view-models
- Re-fetch profile and permissions
- Reset SyncEngine

## Verification

Before merging:
1. Run `bash scripts/audit-tenant-scope.sh` — must pass
2. Add multi-tenant isolation test in `HogwartsTests/<feature>/<feature>-tenant-isolation-tests.swift`
3. Test scenario: create record in school A, switch to school B, verify NOT visible

## Reference

See `docs/multitenancy.md` for the full invariants checklist.
