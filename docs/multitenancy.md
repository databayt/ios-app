# Multi-Tenancy Invariants

> `schoolId` is sacred. Every story respects it.

## Architecture

Hogwarts is a multi-tenant SaaS where each `School` is an isolated tenant. iOS clients never see cross-tenant data.

```
JWT (issued by web)              iOS                                   Backend
─────────────────                ──────                                ────────
{                                APIClient sends:                       Server reads JWT,
  "sub": "user-123",             Authorization: Bearer <jwt>            scopes Prisma:
  "schoolId": "kingfahad",  ──►  X-School-Id: kingfahad         ──►    where: {
  "role": "STUDENT",             (header is secondary signal)             schoolId: jwt.schoolId
  "exp": 1...                                                           }
}
```

## TenantContext

`hogwarts/core/auth/tenant-context.swift` is the single source of truth at runtime.

```swift
@MainActor
@Observable
final class TenantContext {
    static let shared = TenantContext()

    private(set) var currentSchoolId: String?
    private(set) var currentSchoolName: String?
    private(set) var currentRole: UserRole?
    private(set) var currency: String = "USD"  // overridden per school
    private(set) var languageDefault: String = "ar"  // overridden per school

    func require() throws -> String {
        guard let id = currentSchoolId else { throw TenantError.notSet }
        return id
    }
}
```

Every ViewModel that fetches data reads from `TenantContext`, NOT from view arguments.

## SwiftData Scoping

Every `@Model` carries `schoolId: String`. Every `FetchDescriptor` includes the predicate.

```swift
@Model
final class StudentModel {
    @Attribute(.unique) var id: String
    var schoolId: String  // REQUIRED
    var name: String
    var grade: String
    // ...
}

// In service / view-model:
let schoolId = try TenantContext.shared.require()
let descriptor = FetchDescriptor<StudentModel>(
    predicate: #Predicate { $0.schoolId == schoolId },
    sortBy: [SortDescriptor(\.name)]
)
```

### CI Gate

`scripts/audit-tenant-scope.sh` greps for `FetchDescriptor` without `schoolId` predicate.

## Cache Tenancy

Image cache, document cache, search index — all keyed `<schoolId>:<resource-id>`.

```swift
let cacheKey = "\(schoolId):\(imageId)"
ImageCache.shared.get(cacheKey)
```

School switch invalidates all caches:

```swift
func switchSchool(to newSchoolId: String) async throws {
    try await imageCache.invalidate(prefix: TenantContext.shared.currentSchoolId)
    try await documentCache.invalidate(prefix: TenantContext.shared.currentSchoolId)
    TenantContext.shared.set(schoolId: newSchoolId)
}
```

## Multi-School Users

Rare but real:
- Guardians with kids in two schools
- Teachers with shifts at two schools
- District admins who oversee multiple schools

UX: Profile → Schools → tap to switch. Each school is a separate session; data stays isolated.

## Cross-Tenant Action Protection

The JWT carries `schoolId` — server enforces. Client also defends:

```swift
// Verify response payload tenant matches our context
guard response.schoolId == TenantContext.shared.currentSchoolId else {
    throw TenantError.crossTenantViolation
}
```

This catches the (very rare) case where a server bug returns wrong-school data.

## Audit Log

Every mutation logs `tenant_id`, `user_id`, `action`, `entity_id`. Backend has `AuditLog` Prisma model.

```swift
// hogwarts/core/audit/audit-log.swift
struct AuditEvent {
    let tenantId: String     // schoolId
    let userId: String
    let action: String       // "attendance.mark", "fee.pay", "message.send"
    let entityId: String?
    let timestamp: Date
}
```

## Demo Mode

`AUTH-017` Demo Mode = read-only sandbox tenant `demo.databayt.org`. Demo users see realistic data for the demo school, no real data leaks.

## Verification (per story)

- [ ] Every new `@Model` has `schoolId: String` field
- [ ] Every new `FetchDescriptor` includes `schoolId` predicate
- [ ] Every new ViewModel reads `TenantContext.shared`, not view-arg
- [ ] Every new cache key includes school prefix
- [ ] Every new mutation writes to `AuditLog`
- [ ] Multi-tenant isolation test exists in `HogwartsTests/`
- [ ] `scripts/audit-tenant-scope.sh` passes
