---
code: PROFILE
title: User Profile
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: ["/api/mobile/profile"]
i18n_namespaces: [profile, common]
multi_tenant: required
---

# PROFILE — User Profile

## Goal
Profile management for every role: header with avatar/role badge/school, edit (name, phone, bio), avatar upload, About / Help / Achievements / Activity Log, connected accounts, multi-school list and switcher.

## Scope

**In**: Profile view, edit, avatar upload with crop, About, Help, achievements, activity log, connected accounts, schools list + switch.

**Out**: App-level settings (SETTINGS), notifications preferences (NOTIF), security (AUTH), wellbeing records (WELLBEING).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| PROF-001 | Profile view (header, avatar, role badge, school) | 3 | M0 | all |
| PROF-002 | Profile edit (name, phone, bio) | 3 | M0 | all |
| PROF-003 | Avatar upload with crop | 5 | M0 | all |
| PROF-004 | About view (version, build, credits) | 1 | M0 | all |
| PROF-005 | Help center (in-app articles + contact support) | 5 | M1 | all |
| PROF-006 | Achievements showcase | 3 | M1 | student |
| PROF-007 | Activity log (last logins, sessions) | 3 | M1 | all |
| PROF-008 | Connected accounts (Google/Apple/Facebook unlink) | 3 | M1 | all |
| PROF-009 | Schools list + add/switch | 3 | M0 | all |

## Cross-cutting checks
- [ ] All strings localized (profile namespace)
- [ ] Avatar storage tenant-scoped
- [ ] Multi-school switching invalidates caches
- [ ] Activity log fetched from `AuditLog` (own user only)
- [ ] Help articles available offline (bundled)

## Backend dependencies
- ✅ `GET/PUT /api/mobile/profile` — live
- 🟡 Avatar upload endpoint — verify multipart support

## Definition of Done
- [ ] User can edit name, phone, bio; changes persist across logout/login
- [ ] Avatar uploads in <5s on LTE
- [ ] Activity log shows last 10 sessions with device
- [ ] Multi-school user can switch from PROF-009 → see only that school's data
