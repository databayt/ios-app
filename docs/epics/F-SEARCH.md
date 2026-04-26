---
code: F-SEARCH
title: Spotlight & Universal Search
phase: M1
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: ["/api/mobile/search (NEW)"]
i18n_namespaces: [common]
multi_tenant: required
---

# F-SEARCH — Spotlight & Universal Search

## Goal
Tenant-aware universal search across students, classes, messages, announcements, events, fees. Core Spotlight indexing for system-wide search. NSUserActivity continuation for deep-launch from Spotlight results.

## Scope

**In**: Core Spotlight indexer (per-feature), in-app universal search bar, results scoped to tenant + role, recent searches, suggestions, Spotlight donation API.

**Out**: Per-feature search UX (e.g., conversation search lives in MESSAGING).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| SRCH-001 | Core Spotlight indexing (students, classes, messages, announcements, events) | 5 | M1 | all |
| SRCH-002 | In-app universal search bar with NSUserActivity continuation | 5 | M1 | all |
| SRCH-003 | Search results scoped to tenant + role | 3 | M1 | all |
| SRCH-004 | Recent searches + suggestions | 2 | M1 | all |
| SRCH-005 | Spotlight donation API (frequently used items) | 2 | M2 | all |

## Cross-cutting checks
- [ ] Indexed items include `domain identifier` `<schoolId>:<entityType>` for tenant isolation
- [ ] School switch deletes prior tenant's index
- [ ] Search labels localized in indexed `attributeSet`
- [ ] Permissions enforced at result rendering (don't show what user can't access)

## Backend dependencies
- 🔴 **NEW** `GET /api/mobile/search?q=...&types=...` — universal scoped search

## Definition of Done
- [ ] System Spotlight surfaces a class name → tap → app opens to class
- [ ] In-app search "Ahmed" returns matching students/conversations
- [ ] School switch → previously indexed items gone
