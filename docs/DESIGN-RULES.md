# Design Rules — iOS App

> Authoritative rules for how new UI work lands in this repo. Every story in the [Production Roadmap](./epics/PRODUCTION-OVERVIEW.md) must obey these. Mirrors the web app's [architecture](https://ed.databayt.org/en/docs/architecture) and [structure](https://ed.databayt.org/en/docs/structure) docs, adapted for SwiftUI on iOS 18+ / iPad 26.

## Sources of truth

| What | Where | Why |
|------|-------|-----|
| **Web architecture** | https://ed.databayt.org/en/docs/architecture | Mirror pattern, component hierarchy, tenant rules, type-chain |
| **Web structure** | https://ed.databayt.org/en/docs/structure | Folder layout, file naming, suffix conventions |
| **Android (lead mobile)** | https://github.com/databayt/android-app | Feature cadence — iOS lags Android by 1 sprint and adopts the same module layout |
| **Figma iOS / iPad 26** | https://www.figma.com/design/WJPT23xMx4B6oXrCavmHbQ/iso | Pixel-level visual reference. Requires Figma access; engineers must open the file before claiming a UI story done. |
| **Apple HIG / iOS 26 + Liquid Glass** | Apple developer docs | iOS-native idioms (App Intents, Liquid Glass, Action Button, AppShortcuts) |

When the web doctrine and the iOS platform idiom collide, **iOS idiom wins for visual + interaction** (e.g. SwiftUI presentation modifiers, system gestures, Liquid Glass materials) and **web doctrine wins for data model + naming + tenant scope** (kebab-case files, schoolId predicate on every query, mirror-pattern folder).

## Component hierarchy

The web has six layers (Radix → shadcn → ecosystem → blocks → micros → apps). iOS collapses that to **four**, because we don't have a third-party primitives layer separate from SwiftUI:

| Layer | iOS location | What lives here | Example |
|-------|--------------|-----------------|---------|
| **1. UI** | `hogwarts/shared/ui/` | Thin wrappers around SwiftUI / Apple system views; no business logic; one widget per file | `apple-materials.swift`, `sync-status-banner.swift` |
| **2. Atom** | `hogwarts/shared/atom/` | Composition of **2+ UI primitives** into a reusable pattern; no business logic; `hw-` prefix; depends only on `shared/ui/` and `shared/ui/design-system/` | `hw-list-row.swift`, `hw-search-bar.swift`, `hw-text-field.swift`, `hw-action-sheet.swift` (21 exist today) |
| **3. Template** | `hogwarts/shared/template/` *(create when first needed)* | Full-page layouts that compose atoms but are content-agnostic | (none yet — `home-screen.swift` would graduate here when it stops being feature-specific) |
| **4. Block** | `hogwarts/features/{feature}/` | A feature folder — UI + business logic + multi-tenant + API. The **product**, not the toolbox. | `features/attendance/`, `features/messages/` |

**Rule:** When building a new screen, compose from atoms (layer 2) downward. If an atom doesn't exist, add it under `shared/atom/` before using it in a feature — never inline a "private" composition inside a feature folder. If a primitive doesn't exist in `shared/ui/`, write it there first.

**Rule:** A feature folder never imports from another feature folder. Cross-feature reuse goes through atoms or templates.

## Mirror pattern (iOS adaptation)

Web has `app/[lang]/feature/page.tsx` (routing) and `components/feature/content.tsx` (logic) — a 1:1 split. iOS uses a single feature folder with internal layering:

```
hogwarts/features/{feature}/
├── views/                    # SwiftUI views (the "content.tsx" + form.tsx equivalents)
│   ├── {feature}-content.swift     # Main entry view — mirrors web content.tsx
│   ├── {feature}-detail-view.swift # Detail screens
│   └── {feature}-{role}-view.swift # Role-specific variants if needed
├── viewmodels/               # @Observable @MainActor — mirrors React hooks (use-{feature}.ts)
│   └── {feature}-view-model.swift
├── services/                 # Network actions — mirrors web actions.ts
│   └── {feature}-actions.swift     # Async functions hitting /api/mobile/*
├── models/                   # Codable DTOs + @Model SwiftData entities
│   └── {feature}.swift             # Mirrors web types.ts that map to Prisma models
└── helpers/                  # Validation, navigation routers, typed errors
    ├── {feature}-types.swift       # Mirrors web types.ts that are pure types
    └── {feature}-validation.swift  # Mirrors web validation.ts (Zod equivalent)
```

The route lives in `MainTabView` / `ContentView` in `hogwarts/app/`. The web `page.tsx` → iOS `MainTabView` tab; the web `content.tsx` → iOS `{feature}-content.swift`.

## File naming

- **kebab-case** for every file: `notification-router.swift`, `home-view-model.swift`, never `NotificationRouter.swift` or `HomeViewModel.swift`. (Type names inside the file are still PascalCase.)
- **Suffix conventions** mirror web:

| Web suffix | iOS suffix | Where |
|------------|------------|-------|
| `-content.tsx` | `-content.swift` | `views/` |
| `-actions.ts` | `-actions.swift` | `services/` |
| `-validation.ts` | `-validation.swift` | `helpers/` |
| `-types.ts` | `-types.swift` | `helpers/` (pure types) or `models/` (Codable DTOs) |
| `use-{feature}.ts` | `-view-model.swift` | `viewmodels/` |

## Atomic composition rules

1. **Atoms compose UI primitives.** Two or more `shared/ui/` (or SwiftUI) elements composed with a stable contract → that's an atom. One primitive wrapped with a tweak is not an atom; that's a UI layer concern.
2. **Atoms are content-agnostic.** They take inputs (text, icons, actions) and render. They do NOT call APIs, mutate global state, or know about features.
3. **Atoms prefix with `hw-`.** Examples: `hw-button`, `hw-card`, `hw-list-row`, `hw-text-field`, `hw-search-bar`, `hw-badge`, `hw-avatar`. Already 21 in `hogwarts/shared/atom/` — extend, don't fork.
4. **Atoms honor the design system.** Colors via `hogwarts-colors.swift`, typography via `hogwarts-typography.swift`, no hardcoded hex codes, no hardcoded font sizes, no hardcoded paddings beyond the `Spacing` tokens.
5. **Atoms are bilingual + RTL by default.** Use `.leading`/`.trailing` edges, never `.left`/`.right`. Layout flips automatically via `@Environment(\.layoutDirection)`.
6. **Atoms are accessible.** Every interactive atom needs an `accessibilityLabel` (localized via `String(localized:)`) + appropriate `accessibilityRole` / `accessibilityHint` / `accessibilityCustomActions`.

## Reusability discipline

Before writing a new view component, check in this order:

1. `hogwarts/shared/atom/` — does an atom already cover this?
2. `hogwarts/shared/ui/design-system/` — are there tokens (colors, typography, icons, materials) to reuse?
3. `databayt/android-app` — does the parallel Android feature have a layout we should mirror in cadence (not visual style)?
4. The [Figma iOS file](https://www.figma.com/design/WJPT23xMx4B6oXrCavmHbQ/iso) — has the designer specified this screen?
5. Web app at `databayt/hogwarts/src/components/<feature>/` — what's the data shape + interaction the user expects?

Only if all five say "no" do you invent. New atoms land in `shared/atom/` with a one-line doc comment + the role they serve in the composition pyramid.

## Multi-tenant + data flow rules

Mirror web's "Zod → TypeScript → Prisma" type chain as **Swift → Codable DTO → SwiftData @Model**. Specifically:

1. Every API call goes through `APIClient` to `/api/mobile/*`, JWT carries `schoolId`.
2. Every SwiftData `#Predicate` filters by `schoolId` — even local-only queries.
3. `TenantContext` (`hogwarts/core/auth/tenant-context.swift`) is the single source of `currentSchoolId` for the UI.
4. School switch → `TenantContext.clear()` + drop the SwiftData container + reload (preserve no cross-tenant data).
5. Audit-log mutation events (CORE-006, when shipped) automatically include `schoolId` + `userId` + action.

## i18n + RTL rules

- All user-facing strings via `String(localized: "key.path")` — no inline literals.
- Keys live in `hogwarts/resources/Localizable.xcstrings`; AR + EN parity is a CI gate (CORE/Q-TEST stories).
- AR-Indic digits per locale: use `Locale.current` formatters, not custom string interpolation.
- `@Environment(\.layoutDirection)` drives icon mirroring + leading/trailing edges.
- App-level language override at `HogwartsApp.resolvedLocale` — already wired.

## Apple platform idioms (override SwiftUI defaults)

- **Liquid Glass materials** for surfaces — `.ultraThinMaterial` / `.thinMaterial` / `.regularMaterial` as per design system rules in `apple-materials.swift`. Gate iOS 26-only effects with `@available(iOS 26, *)`.
- **Continuous corners** everywhere — `RoundedRectangle(cornerRadius: x, style: .continuous)`.
- **SF Symbols 6** for icons. Custom icons land in `hogwarts/shared/ui/design-system/wa-icons.swift` only when SF Symbols can't cover.
- **App Intents + AppShortcuts** for system integration (per F-INTENTS epic). Already started in `hogwarts/app/app-shortcuts.swift`.
- **iPad** uses `NavigationSplitView`; phone uses `NavigationStack` + `TabView`. Same view models, different containers (per F-PLATFORM-CORE story PLT-010).

## When to consult the Figma file

Open https://www.figma.com/design/WJPT23xMx4B6oXrCavmHbQ/iso whenever:
- Pixel spacing / typography needs to match a designer-specified layout
- A new atom is proposed (verify the variant matrix matches Figma)
- An iPad layout deviates from iPhone (Figma is the only place this is reconciled with iOS 26 idioms)
- A new "Liquid Glass" material treatment is needed (designer has tuned for legibility on the school dashboards)

A UI story is **not done** until the implementer has opened the relevant Figma frame and the rendered iOS view matches within ±2pt on the major axes.

## Cross-reference

- [PRODUCTION-OVERVIEW.md](./epics/PRODUCTION-OVERVIEW.md) — sprint plan
- [F-DESIGN.md](./epics/F-DESIGN.md) — design system epic (Liquid Glass, tokens, motion)
- [SHIP.md](./epics/SHIP.md) — App Store launch
- Web [architecture](https://ed.databayt.org/en/docs/architecture) + [structure](https://ed.databayt.org/en/docs/structure)
- [Android app](https://github.com/databayt/android-app) — the lead mobile reference
