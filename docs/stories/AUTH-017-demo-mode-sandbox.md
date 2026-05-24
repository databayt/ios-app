# AUTH-017: Demo Mode (Read-Only Sandbox Tenant)

**Epic**: AUTH
**Priority**: P0
**Phase**: M0
**Status**: pending
**Effort**: S
**Roles**: [admin, teacher, student, guardian, accountant, staff]
**Multi-Tenant**: required

## User Story
As a prospect, I want a "Demo mode" that loads a read-only sandbox school, so that I can explore the app before signing up.

## Acceptance Criteria
### AC-1: Enter demo
**Given** the welcome screen **When** the user taps "Try Demo" **Then** a demo session is created (no real sign-in) and TenantContext is populated with `demo` schoolId; sample data loads.

### AC-2: Read-only enforcement
**Given** the user is in demo **When** they attempt a mutation (post message, mark attendance) **Then** an inline modal explains "Sign up to perform this action".

### AC-3: Exit demo
**Given** Settings → Account in demo **When** user taps "Exit demo" **Then** session is cleared and the welcome screen reappears.

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `auth`, `onboarding`)
- [ ] RTL-tested
- [ ] schoolId scope (demo is its own tenant)
- [ ] Role-gated (demo role profile)
- [ ] Audit logged (demo.entered, demo.exited)

## Files
- `hogwarts/features/auth/views/welcome-view.swift` — Try Demo CTA
- `hogwarts/core/auth/demo-mode-service.swift` — bootstrap
- `hogwarts/core/auth/tenant-context.swift` — demo flag
- `hogwarts/core/middleware/read-only-mutation-guard.swift` — interceptor

## API Contract
- `POST /api/mobile/auth/demo` — returns `{ access, refresh, user, schoolId: "demo" }`

## i18n Keys
- `auth.demo.cta`
- `auth.demo.banner`
- `auth.demo.signUpToContinue`
- `auth.demo.exit`

## Tests
- `HogwartsTests/auth/demo-mode-tests.swift`
- Read-only enforcement test for mutations

## Dependencies
- Depends on: AUTH-006
- Blocks: ONBOARD-005

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
