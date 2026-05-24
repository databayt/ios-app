---
code: GRADES
title: Grades & GPA
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/grades/*", "/api/mobile/teacher/classes/:id/grades"]
i18n_namespaces: [marking, results]
multi_tenant: required
---

# GRADES — Grades & GPA

## Goal
Student/guardian grade viewing with filters, term selector, GPA cards, charts. Teacher grade entry per assessment, bulk entry, rubric-based grading, publish workflow.

## Scope

**In**: Student-side list + detail + GPA + charts + filters. Teacher entry + bulk + rubric + publish.

**Out**: Report card aggregation (REPORTCARD epic), exam results (EXAMS epic).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| GRADE-001 | List by subject with filter chips (exam/quiz/assignment/midterm/final) | 5 | M0 | student, guardian |
| GRADE-002 | Grade detail (rubric, comments) | 3 | M0 | student, guardian |
| GRADE-003 | GPA summary card (cumulative, term) | 3 | M0 | student, guardian |
| GRADE-004 | Charts (trend by term, by subject) | 5 | M1 | student, guardian |
| GRADE-005 | Term selector | 2 | M0 | student, guardian |
| GRADE-T-001 | Grade entry per assessment | 5 | M1 | teacher |
| GRADE-T-002 | Bulk grade entry (CSV-style) | 5 | M2 | teacher |
| GRADE-T-003 | Rubric-based grading | 8 | M2 | teacher |
| GRADE-T-004 | Publish grades to students | 3 | M1 | teacher |

## Cross-cutting checks
- [ ] Numbers locale-formatted (Arabic-Indic in ar)
- [ ] GPA scale per `School.gradingScale`
- [ ] Comments render in entity content lang
- [ ] Teacher entry validates via Zod-equivalent (range, required)
- [ ] Permission gates strict

## Backend dependencies
- ✅ `GET /api/mobile/grades/student/:id`, `/grades/summary/:id` — live
- 🔴 `POST /api/mobile/teacher/classes/:id/grades` — P1 backend

## Definition of Done
- [ ] Student sees grades by subject with chip filter
- [ ] GPA card matches server calculation
- [ ] Charts render in both ar and en with correct numerals
- [ ] Teacher enters grade → publishes → student sees within 5s
