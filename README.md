# Hogwarts iOS

Native iOS companion app for the Hogwarts school management platform.

## Tech Stack

- **Swift 6.0+** / **SwiftUI** / **iOS 18+**
- **SwiftData** - Offline-first persistence
- **MVVM + Clean Architecture** - Testable, scalable
- **BMAD Method** - Agile AI-driven development

## Quick Start

```bash
# Open in Xcode
open Hogwarts.xcodeproj

# Or via command line
xcodebuild -scheme Hogwarts -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Architecture

### Feature-Based Structure (Mirrors Hogwarts Web)

```
Hogwarts/
├── App/                          # App entry point
├── Core/                         # Shared infrastructure
│   ├── Network/                  # API client, endpoints
│   ├── Storage/                  # SwiftData, sync engine
│   ├── Auth/                     # Authentication
│   └── Extensions/               # Swift extensions
│
├── Shared/
│   ├── UI/                       # UI primitives (Button, Card, Input)
│   ├── Atom/                     # Composed components (2+ UI primitives)
│   └── Utils/                    # Utilities
│
└── Features/                     # Feature modules
    └── {Feature}/                # e.g., Students, Attendance
        ├── Models/
        │   └── {Feature}.swift           # Data models
        ├── Views/
        │   ├── {Feature}Content.swift    # Main view (mirrors content.tsx)
        │   ├── {Feature}Form.swift       # Form view (mirrors form.tsx)
        │   └── {Feature}Table.swift      # Table view (mirrors table.tsx)
        ├── ViewModels/
        │   └── {Feature}ViewModel.swift  # Business logic
        ├── Services/
        │   └── {Feature}Actions.swift    # API calls (mirrors actions.ts)
        └── Helpers/
            ├── {Feature}Validation.swift # Validation (mirrors validation.ts)
            └── {Feature}Types.swift      # Types (mirrors types.ts)
```

### Component Hierarchy (Atomic Design)

```
1. UI         → Shared/UI/         # Primitives (Button, Input, Card)
2. Atom       → Shared/Atom/       # Composed (2+ UI primitives)
3. Feature    → Features/{name}/   # Business components
4. Screen     → Features/{name}/   # Full screens
```

## Multi-Tenant Safety

**CRITICAL**: Always include `schoolId` in API requests.

```swift
// All API calls scoped by schoolId
let students = try await api.get("/students", schoolId: context.schoolId)
```

## Localization

- **Arabic (ar)** - RTL, default
- **English (en)** - LTR

## BMAD Workflow

| Phase | Status | Command |
|-------|--------|---------|
| Analysis | Complete | `/ios-analyst` |
| Planning | Complete | `/ios-architect` |
| Solutioning | In Progress | `/ios-architect` |
| Implementation | Pending | `/ios-dev` |

### Agent Commands

```bash
/ios-analyst    # Requirements analysis
/ios-architect  # Architecture decisions
/ios-dev        # Swift implementation
/ios-qa         # Testing
/ios-ui         # SwiftUI components
/ios-status     # Workflow status
/ios-next       # Advance workflow
```

## Offline-First

All features work offline with automatic sync:

| Feature | Offline | Sync |
|---------|---------|------|
| Dashboard | View cached | On launch |
| Attendance | View + queue | Real-time |
| Grades | View cached | Pull refresh |
| Messages | View + queue | Real-time |

## Testing

```bash
# Unit tests
xcodebuild test -scheme Hogwarts

# UI tests
xcodebuild test -scheme HogwartsUITests
```

**Target**: 80%+ code coverage

## Design Language

The app uses Apple's native design language with iOS 26 aesthetic:

- **Liquid Glass** - glassmorphism with frosted background materials
- **Continuous Corners** - squircle shapes (RoundedRectangle style: .continuous)
- **Native Materials** - .ultraThinMaterial, .thinMaterial, .regularMaterial
- **SF Symbols** - hierarchical rendering for consistent icons
- **Context Menus** - long-press actions on interactive elements
- **Inset Grouped Lists** - native iOS form styling
- **Standardized Shadows** - consistent elevation system

The design system is documented in [Apple Design Guidelines](docs/apple-design-guidelines.md).

## TestFlight Distribution

Distribute beta builds to testers via Apple's TestFlight service:

### Quick Start

```bash
# Archive for TestFlight (requires Apple Developer account + Team ID)
./scripts/archive-for-testflight.sh YOUR_TEAM_ID

# Build artifacts:
# - build/Hogwarts.xcarchive (archive)
# - build/Hogwarts.ipa (app binary)
```

See [TestFlight Distribution Guide](docs/testflight-distribution.md) for complete setup instructions.

### Prerequisites

- Apple Developer Account ($99/year)
- Team ID from developer.apple.com
- App record in App Store Connect
- Provisioning profiles configured

## Documentation

- [PRD](docs/prd.md) - Product requirements
- [Architecture](docs/architecture.md) - Technical design
- [Apple Design Guidelines](docs/apple-design-guidelines.md) - Design system (Liquid Glass, materials, spacing)
- [TestFlight Distribution](docs/testflight-distribution.md) - Beta testing setup
- [Workflow Status](docs/bmad-workflow-status.yaml) - BMAD tracking

## Related

- [Hogwarts Web](https://ed.databayt.org) - Web platform
- [BMAD Method](https://github.com/bmad-code-org/BMAD-METHOD) - Development methodology
