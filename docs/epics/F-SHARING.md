---
code: F-SHARING
title: Share Sheet & AirDrop
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: []
i18n_namespaces: [common]
multi_tenant: required
---

# F-SHARING — Share Sheet & AirDrop

## Goal
First-class native sharing: ShareLink for entities (announcements, events, assignments, report cards), custom UIActivity actions, rich link previews via LPLinkMetadata, AirDrop with tenant-aware deep-links, Handoff between iPhone and iPad.

## Scope

**In**: ShareLink wiring on every shareable entity, custom UIActivity ("Save Receipt", "Save Report Card"), LPLinkMetadata for previews, AirDrop deep-links, Handoff via NSUserActivity.

**Out**: Specific entity-share UX (lives in feature epic; F-SHARING is the substrate).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| SHR-001 | ShareLink for announcements, events, assignments | 2 | M0 | all |
| SHR-002 | Custom UIActivity actions (Save Receipt, Save Report Card) | 3 | M1 | all |
| SHR-003 | LPLinkMetadata for rich previews when sharing entities | 3 | M1 | all |
| SHR-004 | AirDrop support with tenant-aware deep links | 3 | M1 | all |
| SHR-005 | Handoff between iPhone and iPad | 5 | M2 | all |

## Cross-cutting checks
- [ ] Shared deep links include `school_id` (tenant verification on receive)
- [ ] Shared metadata title/subtitle localized to recipient's app lang on render
- [ ] Universal link domain `kingfahad.databayt.org` configured
- [ ] Handoff activities tagged with role context

## Backend dependencies
None — universal links + Apple App Site Association already configured.

## Definition of Done
- [ ] Share announcement via Messages → recipient opens app to detail screen
- [ ] AirDrop assignment to phone → opens to assignment detail
- [ ] Handoff iPhone → iPad continues editing message draft
