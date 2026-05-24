---
code: Q-TEST
title: Test Infrastructure
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: []
i18n_namespaces: []
multi_tenant: required
---

# Q-TEST — Test Infrastructure

## Goal
Establish 80%+ coverage on services + view-models. Swift Testing for unit, XCTest for UI, snapshot tests in `light × dark × LTR × RTL` × `Dynamic Type 1x/3x`. End-to-end critical-path coverage. Multi-tenant isolation tests.

## Scope

**In**: Test harness, MockAPIClient v2, SwiftData in-memory, snapshot infra, UI smoke, E2E auth/attendance/fees, RTL tests, multi-tenant tests, perf tests, accessibility tests.

**Out**: Specific feature unit tests (each feature epic owns its tests).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| TEST-001 | Swift Testing migration audit + harness | 3 | M0 | all |
| TEST-002 | MockAPIClient v2 with fixtures per feature | 5 | M0 | all |
| TEST-003 | SwiftData test container (in-memory) | 3 | M0 | all |
| TEST-004 | Snapshot tests (atoms + key screens, light/dark/RTL) | 5 | M0 | all |
| TEST-005 | UI smoke tests per critical path | 5 | M0 | all |
| TEST-006 | E2E auth flow (XCUITest) | 3 | M0 | all |
| TEST-007 | E2E attendance flow | 3 | M1 | teacher |
| TEST-008 | E2E fees+payment flow | 5 | M1 | guardian |
| TEST-009 | RTL/locale snapshot tests (every screen) | 5 | M0 | all |
| TEST-010 | Multi-tenant isolation tests (school A data not leaked to B) | 5 | M0 | all |
| TEST-011 | Performance tests (XCTMetrics) | 3 | M1 | all |
| TEST-012 | Accessibility tests (Audit API) | 3 | M0 | all |

## Cross-cutting checks
- [ ] Snapshot tests cover every atom + key screens × {light, dark} × {LTR, RTL} × {1x, 3x}
- [ ] Multi-tenant isolation test exists in HogwartsTests/<feature>/
- [ ] E2E tests run on every PR via CI
- [ ] Coverage gate: 80% on `core/` and `services/` and `viewmodels/`

## Backend dependencies
None — all mocked.

## Definition of Done
- [ ] CI runs all test suites <8 min
- [ ] Coverage report: ≥80% on services + viewmodels
- [ ] Snapshot tests cover top 30 screens in 4 variants
- [ ] No flaky tests (3 consecutive green runs)
