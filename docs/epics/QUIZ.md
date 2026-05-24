---
code: QUIZ
title: Quiz Game
phase: M2
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P2
backend_dependencies: ["/api/mobile/quiz/*"]
i18n_namespaces: [generate, common]
multi_tenant: required
---

# QUIZ — Quiz Game

## Goal
Gamified quiz experience for students: practice mode, timed challenges, tournaments, leaderboards, achievements. Drives engagement outside class hours.

## Scope

**In**: Hub, practice, timed, tournament, leaderboard, achievements, session.

**Out**: Formal exams (EXAMS), classroom assessments (ASSIGNMENTS).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| QUIZ-001 | Game hub | 3 | M2 | student |
| QUIZ-002 | Practice mode | 3 | M2 | student |
| QUIZ-003 | Timed challenge | 5 | M2 | student |
| QUIZ-004 | Tournament | 8 | M2 | student |
| QUIZ-005 | Leaderboard | 3 | M2 | student |
| QUIZ-006 | Achievements | 3 | M2 | student |
| QUIZ-007 | Quiz session | 5 | M2 | student |

## Cross-cutting checks
- [ ] Question text in entity content lang
- [ ] Leaderboard scoped by school (no cross-tenant ranking)
- [ ] Achievements use `accessibility` traits for VoiceOver
- [ ] Timer animations respect Reduce Motion

## Backend dependencies
- 🔴 Quiz endpoints — P2 backend

## Definition of Done
- [ ] Student plays practice quiz with 10 questions
- [ ] Tournament joins peer cohort, displays live leaderboard
- [ ] Achievements unlock and persist across sessions
