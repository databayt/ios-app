---
code: ASSIGNMENTS
title: Assignments & Submissions
phase: M1
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: ["/api/mobile/assignments/*"]
i18n_namespaces: [marking, common]
multi_tenant: required
---

# ASSIGNMENTS — Assignments & Submissions

## Goal
Student-side: receive list, detail, file/photo/text submission, submission history, grade + feedback view. Teacher-side: author, review submissions, grade + feedback.

## Scope

**In**: All ASGN-* student stories + ASGN-T-* teacher stories.

**Out**: Online exams (EXAMS), grade aggregation (GRADES, REPORTCARD).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| ASGN-001 | Receive list (by class, by due date) | 3 | M1 | student |
| ASGN-002 | Detail (description, attachments, rubric) | 3 | M1 | student |
| ASGN-003 | File submission (Files app) | 5 | M1 | student |
| ASGN-004 | Photo submission (Camera + scan) | 5 | M1 | student |
| ASGN-005 | Text submission (rich text editor) | 5 | M1 | student |
| ASGN-006 | Submission history + grade view | 3 | M1 | student |
| ASGN-007 | Feedback view (teacher comments) | 3 | M1 | student |
| ASGN-T-001 | Author assignment (form + attachments) | 5 | M2 | teacher |
| ASGN-T-002 | Review submissions list | 5 | M2 | teacher |
| ASGN-T-003 | Grade + feedback | 5 | M2 | teacher |

## Cross-cutting checks
- [ ] Assignment description renders in entity content lang
- [ ] Due date locale-formatted
- [ ] File upload survives app suspend (background URLSession)
- [ ] Photo submission uses VisionKit for scan-and-flatten
- [ ] Permission gates: students see own submissions only

## Backend dependencies
- 🟡 Endpoints — verify or P1/P2 ticket

## Definition of Done
- [ ] Student submits PDF assignment from Files
- [ ] Photo scan flattens warped paper to crisp PDF
- [ ] Grade + feedback visible to student within 5s of teacher publish
