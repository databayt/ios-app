---
code: STREAM
title: LMS Course Stream
phase: M2
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P2
backend_dependencies: ["/api/mobile/stream/*"]
i18n_namespaces: [common]
multi_tenant: required
---

# STREAM — LMS Course Stream

## Goal
Browse LMS courses, enroll, watch video lessons (offline-cacheable), read text lessons, take lesson quizzes, track progress, earn course completion certificates.

## Scope

**In**: Catalog, enrollments, course detail, chapter list, video player (with offline download), text lesson, quiz, progress, certificate.

**Out**: School subjects/catalog (SUBJECTS), assessments (EXAMS), library books (LIBRARY).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| STR-001 | Course catalog | 5 | M2 | student |
| STR-002 | Enrolled courses | 3 | M2 | student |
| STR-003 | Course detail | 3 | M2 | student |
| STR-004 | Chapter list with progress | 3 | M2 | student |
| STR-005 | Video lesson player (offline-cacheable) | 8 | M2 | student |
| STR-006 | Text lesson | 3 | M2 | student |
| STR-007 | Lesson quiz | 5 | M2 | student |
| STR-008 | Course progress | 3 | M2 | student |
| STR-009 | Certificate (PDF) | 5 | M2 | student |
| STR-010 | Download for offline | 5 | M2 | student |

## Cross-cutting checks
- [ ] Video player respects RTL controls layout
- [ ] Subtitles available in `entity.lang`
- [ ] Offline cache scoped to `<schoolId>:<courseId>`
- [ ] Quiz results count toward progress
- [ ] Certificate rendered in entity content lang

## Backend dependencies
- 🔴 All stream endpoints — P2 backend

## Definition of Done
- [ ] Student enrolls in course; appears in enrollments
- [ ] Video lesson plays, supports PiP
- [ ] Download for offline survives app restart
- [ ] Course completion → certificate PDF generated
