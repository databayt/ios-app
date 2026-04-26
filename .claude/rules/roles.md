---
paths: ["hogwarts/features/**/*.swift", "hogwarts/app/**/*.swift"]
description: RBAC enforcement on every feature surface
---

# Role-Based Access Rule

When editing feature views, ViewModels, or navigation:

## Required

- ✅ Every screen guards entry by role: `guard TenantContext.shared.currentRole?.can(.<permission>) == true else { ... }`
- ✅ Every action button / menu item that requires a permission is hidden for non-permitted roles, not just disabled
- ✅ The route table in `home-tile-spec.swift` declares `roles: [UserRole]` per tile
- ✅ Server-side 403 is gracefully handled (show role-mismatch error, suggest switching role/school)

## Permission catalog

`hogwarts/core/auth/authorization.swift` is the single source of truth. Add permissions there as a `Permission` enum case before using.

## Multi-role users

- One role active at a time (current session)
- Switch via Profile → Switch Role → re-fetch profile + permissions
- Some users hold roles in multiple schools — handle as separate sessions

## Frontmatter declaration

Every story declares `roles: [<roles>]` in frontmatter listing all roles that see this surface.

## Reference

See `docs/roles.md` for the full role-feature matrix.
