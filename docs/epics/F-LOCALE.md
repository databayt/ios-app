---
code: F-LOCALE
title: Internationalization & RTL & Content Translation
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/translate (NEW)"]
i18n_namespaces: [common, errors, all]
multi_tenant: required
---

# F-LOCALE — i18n & RTL & Content Translation

## Goal
Make the iOS app fully bilingual (Arabic-default, English-secondary) with first-class RTL support, ≥99% string parity enforced in CI, and on-demand translation of database content respecting each entity's `lang` field. This epic implements the cross-cutting invariants from `docs/i18n.md` system-wide.

## Scope

**In**: String catalog reorg into 20 namespaces, parity tooling, pseudo-locale CI gate, per-app language toggle UX, locale-aware formatters, plural rules, bidi text handling, RTL audit per screen, content-language render with per-card direction overrides, on-demand translate UX, composer language picker, translation cache.

**Out**: Per-screen RTL fixes (handled in feature epics, but tracked here).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| LOC-001 | String catalog reorg into 20 namespaces matching web | 5 | M0 | all |
| LOC-002 | String parity tooling: check-string-parity.sh + CI gate | 3 | M0 | all |
| LOC-003 | Pseudo-locale CI gate (en-XA, ar-XB) | 2 | M0 | all |
| LOC-004 | Per-app language toggle UX polish + zero-restart switch | 3 | M0 | all |
| LOC-005 | Locale formatters (Date, Number, Currency, Measurement) bound to per-tenant School.currency | 5 | M0 | all |
| LOC-006 | Plural rules (stringsdict-equivalent xcstrings) | 2 | M0 | all |
| LOC-007 | Bidi text handling (AttributedString per-language runs) | 3 | M0 | all |
| LOC-008 | RTL audit per screen with screenshots checked into tests/snapshots/rtl/ | 5 | M0 | all |
| LOC-009 | Content-language render: respect entity.lang field | 5 | M0 | all |
| LOC-010 | On-demand translation UX (banner + cache) — POST /api/mobile/translate | 5 | M1 | all |
| LOC-011 | Composer language picker (announcements, messages, assignments) | 3 | M0 | admin, teacher |
| LOC-012 | Translation cache local persistence + invalidation | 3 | M1 | all |

## Cross-cutting checks
- [ ] No hardcoded UI strings (audit script clean)
- [ ] No `.left`/`.right` modifiers (audit script clean)
- [ ] EN+AR parity ≥99% on every PR
- [ ] Pseudo-locale CI gate active
- [ ] Currency formatter uses `TenantContext.currency`, never `Locale.current.currency`
- [ ] Entity content rendered with `entity.lang` font + direction
- [ ] Translate affordance shown when content lang differs from app lang

## Backend dependencies
- 🔴 **NEW** `POST /api/mobile/translate` — proxy to `TranslationCache`. Backend ticket required. Until live: stub on iOS with feature flag.

## Definition of Done
- [ ] String parity ≥99% verified in CI
- [ ] All LOC-* stories merged
- [ ] Spot-check 10 screens in `ar` + `en` show correct layout
- [ ] Pseudo-locale screenshots clean
- [ ] Mixed-language announcement renders correctly to user with opposite app lang
