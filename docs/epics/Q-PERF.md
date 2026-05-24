---
code: Q-PERF
title: Performance
phase: M1
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: []
i18n_namespaces: []
multi_tenant: required
---

# Q-PERF — Performance

## Goal
Hit budgets: cold launch ≤1.5s, warm ≤0.4s, 60fps everywhere (120Hz on supported devices), avg memory ≤150MB, max ≤300MB, ≤3% battery per active hour. Profile-driven, not opinion-driven.

## Scope

**In**: Launch time budget, frame rate, memory, battery, image perf, list perf, background processing.

**Out**: Specific feature optimizations (handled in feature epics, but tracked here).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| PERF-001 | Launch time budget (cold ≤ 1.5s, warm ≤ 0.4s) | 5 | M1 | all |
| PERF-002 | Frame rate budget (60fps everywhere, 120Hz on supported devices) | 5 | M1 | all |
| PERF-003 | Memory budget (avg ≤ 150MB, max ≤ 300MB) | 5 | M1 | all |
| PERF-004 | Battery budget (≤ 3% per hour active) | 3 | M1 | all |
| PERF-005 | Image perf audit (lazy load, downsample) | 3 | M1 | all |
| PERF-006 | List perf audit (.id, prefetch) | 3 | M1 | all |
| PERF-007 | Background processing (off main thread guarantees) | 3 | M1 | all |

## Cross-cutting checks
- [ ] Instruments profile committed (Time Profiler, Allocations) per release
- [ ] MetricKit reports in production
- [ ] No main-thread I/O
- [ ] Image cache hit rate ≥80% on warm cache

## Backend dependencies
None — purely client.

## Definition of Done
- [ ] All budgets met on iPhone 12 (lower-tier) and iPad Air
- [ ] No frame drops on scroll across top 20 lists
- [ ] Memory stable across 30-min usage
- [ ] Battery test green over 1-hour session
