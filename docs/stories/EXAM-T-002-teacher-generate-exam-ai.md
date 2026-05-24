# EXAM-T-002: Teacher Generate Exam (AI-Assisted from QBank)

**Epic**: EXAMS
**Priority**: P2
**Phase**: M2
**Status**: pending
**Effort**: L
**Roles**: [teacher]
**Multi-Tenant**: required

## User Story
**As a** teacher
**I want** to generate an exam draft via AI using parameters (topic, difficulty, length)
**So that** I can produce balanced exams in minutes instead of hours

## Acceptance Criteria

### AC-1: Parameter form
**Given** the teacher taps "Generate" **When** the form appears **Then** they can set subject, topic, count, difficulty mix, target duration; submit triggers a generation job.

### AC-2: Review screen
**Given** generation finishes **When** the result loads **Then** the teacher sees an editable draft and can swap or remove individual questions before publishing.

### AC-3: Source attribution
**Given** AI-suggested questions are pulled from the QBank **When** rendered **Then** each question shows its provenance (existing QBank id or "AI-suggested new").

## Cross-Cutting Invariants
- [ ] Localized strings (namespace: `generate`, `marking`)
- [ ] RTL-tested
- [ ] schoolId predicate
- [ ] Role-gated to teacher
- [ ] Audit logged with `exam.generate`

## Files
- `hogwarts/features/exams/views/teacher-generate-exam-view.swift`
- `hogwarts/features/exams/services/exam-generation-service.swift`
- `hogwarts/features/exams/viewmodels/generate-exam-viewmodel.swift`

## API Contract
- `POST /api/mobile/teacher/exams/generate` — `{ subject, topic, count, difficulty }` → `{ job_id }`
- `GET /api/mobile/teacher/exams/generate/:job_id` — poll status + result

## i18n Keys
- `generate.exam.title`, `generate.exam.parameters`, `generate.exam.review`, `generate.exam.source`

## Tests
- `HogwartsTests/exams/generate-exam-tests.swift`

## Dependencies
- Depends on: EXAM-T-001
- Blocks: none

## Definition of Done
- [ ] AC met, tests pass, RTL screenshot, schoolId scope verified, parity preserved
