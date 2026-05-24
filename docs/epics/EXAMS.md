---
code: EXAMS
title: Exams & Quizzes
phase: M1
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: ["/api/mobile/exams/*"]
i18n_namespaces: [marking, results, generate]
multi_tenant: required
---

# EXAMS — Exams & Quizzes

## Goal
Student-side: upcoming list, detail, online taking with timer + lockdown + violation detection, results, certificate, retake. Teacher-side: author, generate from question bank, manual essay grading, publish.

## Scope

**In**: All EXAM-* student stories + EXAM-T-* teacher stories.

**Out**: Quiz game (QUIZ epic), report card aggregation (REPORTCARD epic).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| EXAM-001 | Upcoming list | 3 | M1 | student |
| EXAM-002 | Exam detail (date, room, subjects, syllabus) | 3 | M1 | student |
| EXAM-003 | Online exam taking (timer, navigation, lockdown) | 13 | M1 | student |
| EXAM-004 | Auto-save answers | 5 | M1 | student |
| EXAM-005 | Violation detection (app switch, screenshot) | 5 | M1 | student |
| EXAM-006 | Submit + confirmation | 3 | M1 | student |
| EXAM-007 | Results view | 3 | M1 | student, guardian |
| EXAM-008 | Certificate (PDF, share) | 5 | M2 | student |
| EXAM-009 | Retake flow | 3 | M2 | student |
| EXAM-T-001 | Author exam from question bank | 8 | M2 | teacher |
| EXAM-T-002 | Generate exam (AI-assisted from QBank) | 8 | M2 | teacher |
| EXAM-T-003 | Grade essays (manual marking) | 5 | M2 | teacher |
| EXAM-T-004 | Publish results | 3 | M1 | teacher |

## Cross-cutting checks
- [ ] Question text renders in entity content lang
- [ ] Timer shows correctly in RTL (mirror progress direction)
- [ ] Violation detection (UIApplication.willResignActive, UIScreen.didCaptureNotification) logged with `school_id`
- [ ] Auto-save every 10s + on app background
- [ ] Lockdown disables share sheet, screenshot disabled where possible

## Backend dependencies
- ✅ `/exams`, `/exams/:id` — live
- 🔴 `POST /exams/:id/answers`, `GET /exams/:id/results`, `POST /exams/:id/violations` — P1
- 🔴 `GET /exams/:id/certificate` — P2

## Definition of Done
- [ ] Student takes a 60-minute exam without timer drift
- [ ] App-switch during exam → violation logged
- [ ] Auto-save survives app crash
- [ ] Teacher grades essay; student sees result within 5s of publish
