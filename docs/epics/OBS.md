---
code: OBS
title: Observability
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: []
i18n_namespaces: []
multi_tenant: required
---

# OBS — Observability

## Goal
Sentry crash reporting, custom event taxonomy (auth, screen views, actions), MetricKit hosted reports, in-app feedback (shake to report), in-app review prompts, segmented analytics by role/school/plan.

## Scope

**In**: Crash reporting, event taxonomy, MetricKit, feedback, review prompts, user properties.

**Out**: Specific feature analytics (each feature taps into the OBS infrastructure).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| OBS-001 | Sentry crash reporting | 3 | M0 | all |
| OBS-002 | Custom event taxonomy (auth, screen views, actions) | 5 | M0 | all |
| OBS-003 | MetricKit hosted reports | 3 | M1 | all |
| OBS-004 | In-app feedback (shake to report) | 5 | M1 | all |
| OBS-005 | In-app review prompts (SKStoreReviewController) | 2 | M1 | all |
| OBS-006 | User properties (role, school, plan) for segmented analytics | 3 | M0 | all |

## Cross-cutting checks
- [ ] Sentry user data: `tenant_id`, `role`, `app_locale` (NO PII like name/email)
- [ ] Event names follow taxonomy (`<feature>.<action>`)
- [ ] Feedback strings localized
- [ ] Review prompts respect Apple guidelines (max 3/year, contextual)

## Backend dependencies
None — Sentry/MetricKit are SaaS or Apple platform.

## Definition of Done
- [ ] Crash from staging build appears in Sentry within 1 minute
- [ ] Event taxonomy documented + enforced
- [ ] Shake gesture opens feedback form
- [ ] User properties enrich every Sentry event
