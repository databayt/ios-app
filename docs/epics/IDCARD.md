---
code: IDCARD
title: Digital ID Card
phase: M1
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: ["/api/mobile/idcard"]
i18n_namespaces: [profile]
multi_tenant: required
---

# IDCARD — Digital ID Card

## Goal
Digital ID with role badge, school branding, barcode/QR for kiosk attendance check-in. Apple Wallet pass for one-tap access. PDF export. NFC for tap-to-check-in.

## Scope

**In**: View, Apple Wallet pass, PDF, share, NFC.

**Out**: Kiosk-mode attendance method (ATTENDANCE epic).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| ID-001 | View (avatar, role, school, barcode/QR) | 3 | M1 | all |
| ID-002 | Apple Wallet pass (PassKit) | 8 | M2 | all |
| ID-003 | PDF export | 3 | M2 | all |
| ID-004 | Share | 1 | M2 | all |
| ID-005 | NFC for kiosk attendance | 5 | M2 | student, staff |

## Cross-cutting checks
- [ ] ID card displays user name in entity content lang
- [ ] QR/barcode includes `<schoolId>:<userId>` payload
- [ ] Wallet pass scoped to school theme/logo
- [ ] Apple Wallet pass refreshable on role change

## Backend dependencies
- ✅ `GET /idcard` — verify or P2 backend
- 🔴 Apple Wallet `.pkpass` endpoint — P2

## Definition of Done
- [ ] User opens ID card; QR scans on kiosk; attendance recorded
- [ ] Apple Wallet shows ID; tap → opens app
- [ ] NFC tap on iPad kiosk records attendance in <1s
