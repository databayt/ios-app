---
code: ADMISSION
title: Admission Applicant Flow
phase: M2
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P2
backend_dependencies: ["/api/mobile/admission/*"]
i18n_namespaces: [common, errors]
multi_tenant: required
---

# ADMISSION — Admission Applicant Flow

## Goal
Public admission flow for prospective parents (USER role): multi-step apply wizard, document upload via VisionKit, OTP-based status check, tour booking, application fee payment, inquiry form. Web has 100% feature; iOS adds native scan + Apple Pay.

## Scope

**In**: Apply wizard, document upload (with VisionKit), OTP status check, tour booking, application fee payment, inquiry form.

**Out**: Internal admin reviewer queue (web-only).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| ADMSN-001 | Apply wizard (multi-step) | 8 | M2 | user |
| ADMSN-002 | Document upload (with VisionKit) | 5 | M2 | user |
| ADMSN-003 | OTP-based status check | 3 | M2 | user |
| ADMSN-004 | Tour booking | 5 | M2 | user |
| ADMSN-005 | Application fee payment | 5 | M2 | user |
| ADMSN-006 | Inquiry form | 3 | M2 | user |

## Cross-cutting checks
- [ ] No login required for public flow
- [ ] All form labels localized
- [ ] OTP delivery via SMS + email (server-side)
- [ ] VisionKit scan crops to A4 doc bounds, B&W
- [ ] School logo + branding from `/api/mobile/schools/:domain`

## Backend dependencies
- 🔴 Admission endpoints — P2

## Definition of Done
- [ ] Public user opens app, taps "Apply", completes wizard
- [ ] Documents scanned, uploaded, recognizable PDFs
- [ ] OTP status check works without login
- [ ] Application fee paid via Apple Pay or card
