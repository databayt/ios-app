---
code: F-MEDIA
title: Media & Files
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P1
backend_dependencies: ["/api/mobile/files (upload)"]
i18n_namespaces: [common]
multi_tenant: required
---

# F-MEDIA — Media & Files

## Goal
Universal media plumbing: image picker (Photos + Camera), document scanner (VisionKit), file picker (Files app), voice recorder, video player, PDF viewer, image cache (Nuke), resumable uploads, media gallery viewer. One epic provides the substrate; feature epics consume it.

## Scope

**In**: Permission-primed media pickers, AVKit player, VisionKit document scanner, AVAudioRecorder voice messages, PDFKit viewer + share, Nuke image cache with tenant keys, resumable upload manager, media gallery for chat attachments.

**Out**: Specific use-cases (assignment submission UI, message attachments — those live in their feature epic).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| MED-001 | Image picker (Photos + Camera) with permission priming | 3 | M0 | all |
| MED-002 | Document scanner via VNDocumentCameraViewController | 3 | M1 | all |
| MED-003 | File picker (Files app integration) | 2 | M1 | all |
| MED-004 | Voice message recorder (AVAudioRecorder) | 5 | M1 | all |
| MED-005 | Video player (AVKit) with subtitle support | 3 | M1 | all |
| MED-006 | PDF viewer + share + print | 3 | M1 | all |
| MED-007 | Image cache (Nuke) with tenant-scoped keys | 3 | M0 | all |
| MED-008 | Resumable upload manager | 5 | M1 | all |
| MED-009 | Media gallery viewer (chat attachments, etc.) | 5 | M1 | all |

## Cross-cutting checks
- [ ] Permission rationale strings localized
- [ ] Cache keys prefixed with `<schoolId>:`
- [ ] Uploads survive app suspension (BGTask continuation)
- [ ] Video player respects RTL controls layout
- [ ] PDF viewer respects content language for headers/captions

## Backend dependencies
- 🟡 Resumable upload endpoint — verify exists or design with backend

## Definition of Done
- [ ] All media pickers usable from any feature
- [ ] 10MB image upload survives backgrounding
- [ ] PDF report card opens, scrolls, shares correctly
- [ ] Voice message records 60s, plays back, sends to chat
