---
code: LIBRARY
title: Library
phase: M2
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P2
backend_dependencies: ["/api/mobile/library/*"]
i18n_namespaces: [library, lab]
multi_tenant: required
---

# LIBRARY — Library

## Goal
School library catalog browse, book detail, search, my borrowings, holds/reservations, return reminders.

## Scope

**In**: Reader stories.

**Out**: Subjects/curriculum reading (SUBJECTS epic), e-books from Stream LMS (STREAM epic).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| LIB-001 | Catalog browse | 5 | M2 | student |
| LIB-002 | Book detail | 3 | M2 | student |
| LIB-003 | Search | 3 | M2 | student |
| LIB-004 | My borrowings | 3 | M2 | student |
| LIB-005 | Hold/reserve | 3 | M2 | student |
| LIB-006 | Return reminder | 2 | M2 | student |

## Cross-cutting checks
- [ ] Book titles render in entity content lang
- [ ] Date returned/due locale-formatted
- [ ] Reminder uses iOS Reminders integration (F-INTEGRATION)
- [ ] Catalog scoped to school's library

## Backend dependencies
- 🔴 All library endpoints — P2 backend

## Definition of Done
- [ ] Student browses catalog, searches "Quran", reserves a book
- [ ] My borrowings shows active loans with due dates
- [ ] Reminder fires 1 day before due date
