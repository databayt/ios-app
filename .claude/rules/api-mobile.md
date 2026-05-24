---
paths: ["hogwarts/features/**/services/*.swift", "hogwarts/core/network/*.swift"]
description: /api/mobile/* contract enforcement for all backend interactions
---

# /api/mobile/* Contract Rule

When implementing service layer (`services/<feature>-actions.swift`):

## Endpoint base

- ✅ All endpoints use `/api/mobile/*` prefix
- ✅ Production: `https://kingfahad.databayt.org/api/mobile/`
- ✅ Demo: `https://demo.databayt.org/api/mobile/`
- ❌ NEVER call non-mobile endpoints (cookie auth, NextAuth session, etc.)

## Request shape

- ✅ `Authorization: Bearer <jwt>` header
- ✅ `Content-Type: application/json`
- ✅ JSON request body with snake_case keys
- ✅ Optional `X-School-Id: <schoolId>` header (server reads JWT claim primarily)

## Response shape

- ✅ Snake_case JSON
- ✅ Always paginated lists with `{ data: [...], meta: { page, pageSize, total } }`
- ✅ Always include `school_id` on entity payloads (verify matches `TenantContext`)
- ✅ Errors: `{ error: { code, message, details? } }`

## Decoding

- ✅ `JSONDecoder.keyDecodingStrategy = .convertFromSnakeCase` is set globally on `APIClient`
- ✅ Date decoding: `JSONDecoder.dateDecodingStrategy = .iso8601`
- ✅ Use `Decodable` structs in `models/` mirroring backend DTOs

## Auth refresh

- ✅ On 401, attempt one refresh via `PUT /api/mobile/auth` with `X-Refresh-Token: <refresh>`
- ✅ On second 401, log user out
- ✅ Token refresh is race-safe (single in-flight refresh, queued requests retry)

## Service file convention

```swift
// hogwarts/features/<feature>/services/<feature>-actions.swift
@MainActor
final class FeatureActions {
    private let api: APIClientProtocol

    init(api: APIClientProtocol = APIClient.shared) {
        self.api = api
    }

    func list() async throws -> [FeatureItem] {
        try await api.get("/mobile/<feature>", as: PagedResponse<FeatureItem>.self).data
    }

    func get(id: String) async throws -> FeatureItem {
        try await api.get("/mobile/<feature>/\(id)", as: FeatureItem.self)
    }
}
```

## Mocking for tests

- ✅ Tests inject `MockAPIClient` (in `HogwartsTests/sync-engine-mock-tests.swift`)
- ✅ Fixtures stored in `HogwartsTests/fixtures/<feature>/*.json`
- ❌ NEVER hit live API in unit tests

## Reference

- Contract source-of-truth: `/Users/abdout/hogwarts/src/app/api/mobile/README.md`
- iOS migration guide: same README, "iOS Swift App" section
- Backend gaps tracker: `docs/backend-gaps.md`
