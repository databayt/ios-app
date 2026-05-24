---
code: SHIP
title: Release & TestFlight
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: []
i18n_namespaces: []
multi_tenant: required
---

# SHIP — Release

## Goal
TestFlight setup, App Store assets in EN+AR, privacy manifest, export compliance, release notes template, phased release strategy, App Review submission + appeal playbook, marketing site.

## Scope

**In**: TestFlight, App Store assets, privacy manifest, export compliance, release notes, phased release, review submission, marketing.

**Out**: Marketing analytics (handled by web team), promotional content design (out of mobile scope).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| SHIP-001 | TestFlight setup + beta group | 3 | M0 | all |
| SHIP-002 | App Store assets (screenshots EN/AR for all device sizes) | 5 | M0 | all |
| SHIP-003 | Privacy manifest finalization | 3 | M0 | all |
| SHIP-004 | Export compliance (encryption use) | 1 | M0 | all |
| SHIP-005 | Release notes template (EN/AR) | 1 | M0 | all |
| SHIP-006 | Phased release rollout strategy | 2 | M1 | all |
| SHIP-007 | App Review submission + appeal playbook | 3 | M0 | all |
| SHIP-008 | Marketing site + App Store optimization | 5 | M1 | all |
| SHIP-009 | Fastlane + GitHub Actions TestFlight pipeline | 3 | M0 | all |

## Cross-cutting checks
- [ ] Screenshots captured in both AR + EN
- [ ] App Store description fully translated
- [ ] Privacy manifest accurate per actual data use
- [ ] Release notes localized
- [ ] Phased rollout starts at 1% → 10% → 50% → 100%
- [ ] TestFlight uploads are reproducible (Fastlane lane, no manual Xcode Organizer steps)

## Backend dependencies
None — all release ops.

## Definition of Done
- [ ] TestFlight private beta has ≥10 testers
- [ ] App Store submission passes review on first attempt
- [ ] Both AR and EN App Store listings live
- [ ] Phased release rollout active for first month
