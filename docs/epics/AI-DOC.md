---
code: AI-DOC
title: AI Document Processing
phase: M2
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P2
backend_dependencies: ["/api/mobile/ai-doc/*"]
i18n_namespaces: [common]
multi_tenant: required
---

# AI-DOC — AI Document Processing

## Goal
Differentiated mobile UX: scan permission slip / report card / consent form / receipt with VisionKit; backend AI extracts structured data via Claude Vision; user reviews + edits + confirms.

## Scope

**In**: VisionKit scan, job submission, status polling, completion notification, extracted data review + edit.

**Out**: Web has the AI processing infrastructure; iOS only consumes job endpoints.

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| AIDOC-001 | Scan permission slip via VisionKit OCR | 5 | M2 | guardian |
| AIDOC-002 | Scan report card → upload to processing job | 5 | M2 | guardian |
| AIDOC-003 | Job status polling + completion notification | 3 | M2 | guardian |
| AIDOC-004 | Extracted data review + edit | 5 | M2 | guardian |

## Cross-cutting checks
- [ ] Scan UI localized (Cancel, Done, Scan)
- [ ] Documents tagged with `school_id` on upload
- [ ] OCR result language detected and stored as `entity.lang`
- [ ] Privacy: scanned images deleted from device after upload

## Backend dependencies
- 🔴 AI-DOC endpoints — P2 backend (job submit, status, result)

## Definition of Done
- [ ] Scan permission slip → upload → job ID returned
- [ ] Push notification on job completion
- [ ] Review extracted data → edit fields → confirm → record created
