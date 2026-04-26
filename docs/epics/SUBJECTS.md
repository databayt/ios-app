---
code: SUBJECTS
title: Subjects Catalog
phase: M1
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: ["/api/mobile/subjects/*"]
i18n_namespaces: [common]
multi_tenant: required
---

# SUBJECTS — Subjects Catalog

## Goal
Browse the school's adopted subjects (catalog), see chapter + lesson structure, view "my subjects" (enrolled), drill into chapter lessons.

## Scope

**In**: Catalog, detail, my subjects, chapters, lesson detail.

**Out**: LMS course playback (STREAM epic), library reading (LIBRARY epic), exam authoring (EXAMS).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| SUB-001 | Catalog (school-adopted subjects) | 3 | M1 | student, teacher |
| SUB-002 | Subject detail (chapters, lessons) | 3 | M1 | student, teacher |
| SUB-003 | My subjects (enrolled) | 3 | M1 | student, teacher |
| SUB-004 | Chapter list | 2 | M1 | student, teacher |
| SUB-005 | Lesson detail | 3 | M1 | student, teacher |

## Cross-cutting checks
- [ ] Subject names render in entity content lang
- [ ] Chapter/lesson order respects RTL grouping
- [ ] Permission gates: only enrolled users see "My Subjects"

## Backend dependencies
- ✅ `GET /catalog/subjects`, `GET /subjects/my-subjects` — live
- 🟡 Chapter + lesson endpoints — verify or P2

## Definition of Done
- [ ] Student sees own subjects with chapter counts
- [ ] Teacher sees teaching subjects with class assignments
- [ ] Tap chapter → list lessons → tap lesson → detail
