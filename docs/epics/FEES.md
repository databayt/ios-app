---
code: FEES
title: Fees & Payments
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/fees/*", "/api/mobile/invoices/*", "/api/mobile/payments/*"]
i18n_namespaces: [finance, banking]
multi_tenant: required
---

# FEES — Fees & Payments

## Goal
Two surfaces: viewing (FEE-* stories — fee list, summary, invoices, receipts) and paying (PAY-* — Apple Pay, Stripe, cash recording, bank receipt upload, refund). Backend P0 gap: invoice + payment endpoints.

## Scope

**In**: All FEE-* + PAY-* stories. Apple Pay via PassKit + Stripe SDK.

**Out**: SaaS subscription billing (SUBSCRIPTION-SAAS epic), accountant operational tools (covered here in PAY-3, PAY-7).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| FEE-001 | Fee list (assignments, balance) | 5 | M0 | guardian, student |
| FEE-002 | Fee summary card | 3 | M0 | guardian, student |
| FEE-003 | Invoice list (P0 backend) | 5 | M1 | guardian, accountant |
| FEE-004 | Invoice detail with line items (P0 backend) | 5 | M1 | guardian, accountant |
| FEE-005 | Receipt list | 3 | M1 | guardian, accountant |
| PAY-001 | Apple Pay (PassKit + Stripe) (P0 backend) | 8 | M1 | guardian |
| PAY-002 | Stripe card sheet (P0 backend) | 8 | M1 | guardian |
| PAY-003 | Cash record (accountant) | 3 | M1 | accountant |
| PAY-004 | Bank receipt upload (photo + verify) | 5 | M1 | guardian, accountant |
| PAY-005 | Payment history (P0 backend) | 3 | M1 | guardian, accountant |
| PAY-006 | Partial payment | 3 | M2 | guardian, accountant |
| PAY-007 | Refund flow | 5 | M2 | accountant |
| PAY-008 | Scholarship application | 5 | M2 | guardian |
| PAY-009 | Fines view | 3 | M2 | guardian, accountant |

## Cross-cutting checks
- [ ] Currency formatter uses `TenantContext.currency`, NOT device locale
- [ ] Numbers locale-formatted (Arabic-Indic in ar)
- [ ] Apple Pay sheet localized
- [ ] Receipt PDF rendered in entity content lang
- [ ] Audit log entry per payment, refund

## Backend dependencies
- ✅ `GET /fees`, `/fees/summary/:studentId` — live
- 🔴 Invoices CRUD — P0
- 🔴 Payments process + history — P0
- 🔴 Refund + scholarship endpoints — P2

## Definition of Done
- [ ] Guardian views fee summary; tuition currency matches school config
- [ ] Apple Pay sheet → success → receipt visible in PAY-005 within 5s
- [ ] Cash record → invoice updated → receipt issued
- [ ] Partial payment leaves remaining balance correct
