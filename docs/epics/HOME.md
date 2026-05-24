---
code: HOME
title: Springboard Home
phase: M0
roles: [admin, teacher, student, guardian, accountant, staff, user]
priority: P0
backend_dependencies: []
i18n_namespaces: [home, common]
multi_tenant: required
---

# HOME — Springboard Home

## Goal
A WhatsApp-style home springboard with a customizable tile grid + dock + wallpaper. Already substantially built (`home-screen`, `home-grid`, `home-dock`, `home-tile-spec`, `home-widget-pages`, wallpapers). This epic formalizes the existing implementation, completes customization, adds notification badges, and supports multi-role users.

## Scope

**In**: Wallpaper picker, paged tile groups (role-aware), tile customization (jiggle/reorder/hide), dock atoms, search pill, Spotlight quick-actions, multi-role switcher, notification badges per tile.

**Out**: Per-feature destinations (each feature epic owns its content).

## Stories
| ID | Goal | Points | Phase | Roles |
|----|------|--------|-------|-------|
| HOME-001 | Wallpaper picker (catalog from Assets.xcassets) | 3 | M0 | all |
| HOME-002 | Widget pages (paged tile groups, role-aware) | 5 | M0 | all |
| HOME-003 | Tile customization (long-press jiggle, reorder, hide) | 8 | M1 | all |
| HOME-004 | Dock atoms (4 fixed shortcuts, role-aware defaults) | 3 | M0 | all |
| HOME-005 | Home search pill (universal search entry) | 3 | M1 | all |
| HOME-006 | Spotlight quick-actions integration | 2 | M1 | all |
| HOME-007 | Multi-role user switcher (rare but real) | 3 | M1 | all |
| HOME-008 | Notification badges per tile | 2 | M0 | all |

## Cross-cutting checks
- [ ] Tile labels localized
- [ ] Tile order respects RTL (right-to-left grid layout)
- [ ] Dock layout flips in RTL
- [ ] Wallpaper assets include both LTR and RTL-friendly variants where needed
- [ ] Tile visibility respects role permissions

## Backend dependencies
None — local UI customization.

## Definition of Done
- [ ] Student home shows student-relevant tiles by default
- [ ] Long-press → jiggle → drag tile → reorder persists
- [ ] Wallpaper picker loads catalog and applies selection
- [ ] Multi-role user can toggle between Teacher and Parent home
