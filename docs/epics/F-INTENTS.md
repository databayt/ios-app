---
code: F-INTENTS
title: App Intents, Siri & Shortcuts
phase: M1
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: []
i18n_namespaces: [common, home]
multi_tenant: required
---

# F-INTENTS — App Intents & Shortcuts

## Goal
Make Hogwarts a first-class Siri/Shortcuts citizen: voice-driven Mark Attendance, Open Today's Schedule, Send Message; Focus Filters per role; Action Button (iPhone 15+) mapping; auto-add to Spotlight.

## Scope

**In**: All AppIntent definitions, parameter providers (class picker, contact picker), Focus Filter intent per role (Teaching Hours, School Hours), Action Button mapping, App Shortcuts auto-add.

**Out**: Widget interactivity (handled in F-PLATFORM-CORE).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| INTENT-001 | Open Dashboard intent (formalize existing) | 2 | M0 | all |
| INTENT-002 | Today's Schedule intent (formalize existing) | 2 | M0 | student, teacher |
| INTENT-003 | Open Messages intent (formalize existing) | 2 | M0 | all |
| INTENT-004 | Mark Attendance intent (parameter: class) | 5 | M1 | teacher |
| INTENT-005 | Send Message intent (parameter: contact, body) | 5 | M1 | all |
| INTENT-006 | Mark Notifications Read intent | 2 | M1 | all |
| INTENT-007 | Pay Fee intent (StoreKit 2 / Apple Pay) | 8 | M1 | guardian |
| INTENT-008 | Focus Filter per role (school hours focus) | 5 | M2 | all |
| INTENT-009 | Action Button mapping (iPhone 15+) | 2 | M2 | teacher |
| INTENT-010 | App Shortcuts auto-add to Spotlight | 2 | M1 | all |

## Cross-cutting checks
- [ ] Intent titles + parameter labels localized
- [ ] Intent execution respects role permissions
- [ ] Intent payloads include `school_id`
- [ ] Voice prompts handle Arabic + English
- [ ] Focus Filter doesn't leak cross-tenant data

## Backend dependencies
None — intents wrap existing endpoints.

## Definition of Done
- [ ] "Hey Siri, mark attendance" with class context works
- [ ] Action Button assigned to "Mark Attendance" launches camera for QR
- [ ] Focus filter "School Hours" silences non-school notifications
