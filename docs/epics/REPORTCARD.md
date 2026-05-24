---
code: REPORTCARD
title: Report Cards
phase: M1
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: ["/api/mobile/report-cards/*"]
i18n_namespaces: [results, marking]
multi_tenant: required
---

# REPORTCARD — Report Cards

## Goal
Term-end report cards with PDF download, share, print, guardian sign-off, and term-over-term progress charts.

## Scope

**In**: List by term, detail, PDF download, share + print, progress charts, guardian acknowledgment signing.

**Out**: Per-grade detail (GRADES epic).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| RC-001 | List by term | 3 | M1 | student, guardian |
| RC-002 | Detail view (subjects, grades, comments) | 5 | M1 | student, guardian |
| RC-003 | PDF download (P1 backend) | 5 | M1 | student, guardian |
| RC-004 | Share + print | 2 | M1 | student, guardian |
| RC-005 | Progress charts (term over term) | 3 | M2 | guardian |
| RC-006 | Sign report card (guardian acknowledgment) | 3 | M1 | guardian |

## Cross-cutting checks
- [ ] PDF rendered server-side respects `report_card.lang`
- [ ] Share sheet localized
- [ ] Sign action recorded with timestamp + device + IP
- [ ] Charts locale-numeric

## Backend dependencies
- 🔴 `GET /api/mobile/report-cards`, `:id`, `:id/pdf` — P1 backend
- 🔴 `POST /api/mobile/report-cards/:id/sign` — P1 backend

## Definition of Done
- [ ] Guardian can view, download, share, sign report card
- [ ] PDF preview opens in PDFKit viewer
- [ ] Sign action persists across app restarts
- [ ] Term-over-term chart shows trend correctly
