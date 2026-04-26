---
code: SUBSCRIPTION-SAAS
title: School SaaS Subscription
phase: M2
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P2
backend_dependencies: ["/api/mobile/subscription/*"]
i18n_namespaces: [sales]
multi_tenant: required
---

# SUBSCRIPTION-SAAS — School SaaS Subscription

## Goal
Admin-only surface for school-level Hogwarts SaaS subscription: view plan, upgrade/downgrade, billing history, payment method, Apple IAP integration via StoreKit 2 for in-app upgrades. Distinct from FEES (parent tuition).

## Scope

**In**: Subscription view, upgrade/downgrade, invoice history, payment method, Apple IAP.

**Out**: Tuition payments (FEES epic), accountant tools (FEES PAY-* stories).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| SUB-S-001 | Subscription view (plan, billing, seats) | 5 | M2 | admin |
| SUB-S-002 | Upgrade/downgrade | 5 | M2 | admin |
| SUB-S-003 | Invoice history | 3 | M2 | admin |
| SUB-S-004 | Payment method | 5 | M2 | admin |
| SUB-S-005 | Apple IAP integration (StoreKit 2) | 8 | M2 | admin |

## Cross-cutting checks
- [ ] Plan names + features localized
- [ ] StoreKit subscriptions follow Apple guidelines
- [ ] Billing currency from subscription model, not device locale
- [ ] Audit log every subscription change

## Backend dependencies
- 🔴 Subscription endpoints — P2 backend
- 🔴 Apple IAP webhook → backend record

## Definition of Done
- [ ] Admin sees current plan + seat usage
- [ ] Upgrade triggers StoreKit purchase sheet → success → backend updated
- [ ] Invoice history with PDF download
