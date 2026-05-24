---
code: MESSAGING
title: Messaging & Chat
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/conversations/*"]
i18n_namespaces: [messaging, whatsapp]
multi_tenant: required
---

# MESSAGING — Messaging & Chat

## Goal
WhatsApp-style direct + group + class messaging with offline send queue, real-time Socket.IO, reactions, read receipts, mentions, threads, search, starred, pinned, archive, mute, leave group. Substantial implementation already exists in `whatsapp-ios/` and `whatsapp-chat/` folders. This epic completes feature parity with web + kotlin.

## Scope

**In**: All MSG-* stories (27 total). Real-time via Socket.IO. Offline queue. Per-message lang rendering.

**Out**: WhatsApp Business bridge details (MSG-025 is M2).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| MSG-001 | Conversations list (with mute/archive/pin filters) | 5 | M0 | all |
| MSG-002 | Chat view (bubbles, per-message lang, RTL-aware) | 8 | M0 | all |
| MSG-003 | Send text | 2 | M0 | all |
| MSG-004 | Send image | 3 | M1 | all |
| MSG-005 | Send file | 3 | M1 | all |
| MSG-006 | Send voice message | 5 | M1 | all |
| MSG-007 | Reactions | 3 | M1 | all |
| MSG-008 | Read receipts | 3 | M0 | all |
| MSG-009 | Typing indicator | 3 | M1 | all |
| MSG-010 | Mentions (@) | 5 | M1 | all |
| MSG-011 | Reply threads | 5 | M1 | all |
| MSG-012 | Search messages | 3 | M1 | all |
| MSG-013 | Starred messages | 3 | M1 | all |
| MSG-014 | Pin message | 2 | M1 | all |
| MSG-015 | Archive conversation | 2 | M0 | all |
| MSG-016 | Mute conversation | 2 | M0 | all |
| MSG-017 | Leave group | 2 | M1 | all |
| MSG-018 | Contacts (school directory) | 5 | M0 | all |
| MSG-019 | Compose new (1:1 + group) | 5 | M0 | all |
| MSG-020 | Link previews | 3 | M1 | all |
| MSG-021 | Emoji picker | 2 | M1 | all |
| MSG-022 | Media gallery (per conversation) | 5 | M1 | all |
| MSG-023 | Conversation info (members, settings) | 3 | M0 | all |
| MSG-024 | Group admin tools (add/remove, role) | 5 | M1 | all |
| MSG-025 | WhatsApp bridge (web QR pairing) | 8 | M2 | all |
| MSG-026 | Socket.IO real-time wire | 8 | M0 | all |
| MSG-027 | Offline send queue with retry | 5 | M0 | all |

## Cross-cutting checks
- [ ] Each bubble renders with its OWN lang/font/direction (chat-level direction does NOT apply to bubbles)
- [ ] Translate affordance per bubble when message lang ≠ app lang
- [ ] Strings localized (messaging + whatsapp namespaces)
- [ ] Read receipts logged with `school_id`
- [ ] Socket disconnect → queue → reconnect drains queue in order

## Backend dependencies
- ✅ Conversations + messages endpoints — live
- ✅ Pin/mute/archive/leave/star — live
- 🟡 Socket.IO server — verify production endpoint

## Definition of Done
- [ ] Send text message → recipient sees within 1s
- [ ] Offline send → queues → reconnect → delivers
- [ ] Voice message records, sends, plays back
- [ ] Search "homework" returns matching messages across conversations
- [ ] Arabic message in English chat renders RTL with translate option
