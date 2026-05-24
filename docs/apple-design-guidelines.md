# Apple Design Guidelines - Hogwarts iOS

This document outlines the Apple Design Language implementation in the Hogwarts iOS app, ensuring consistency with iOS 26's native aesthetic and making the app indistinguishable from Apple's own products.

## Design Philosophy

The Hogwarts app follows Apple's Human Interface Guidelines (HIG) with emphasis on:

1. **Native First** - Use iOS native components (TabView, Lists, Sheets)
2. **Material Design** - Glassmorphism with frosted glass effects
3. **Spatial Design** - Consistent elevation and depth
4. **Clarity** - Clear typography and visual hierarchy
5. **Delight** - Subtle animations and interactions

## Design System Components

### Materials & Glass Effects

The app uses iOS 26's native material system to create the "Liquid Glass" aesthetic:

#### Material Tiers

| Material | Opacity | Use Case | Examples |
|----------|---------|----------|----------|
| `.ultraThinMaterial` | 0.0-0.4 | Overlays, backgrounds | Form backgrounds, sheet backdrops |
| `.thinMaterial` | 0.4-0.6 | Content cards | List rows, form sections, dashboard cards |
| `.regularMaterial` | 0.6-0.8 | Headers, containers | Card headers, hero sections |
| `.thickMaterial` | 0.8-1.0 | Opaque surfaces | Navigation bars, tab bars |

#### Implementation Pattern

All glass containers follow this pattern:

```swift
VStack(alignment: .leading, spacing: 12) {
    // Content
}
.padding()
.background(
    .thinMaterial,  // Material tier
    in: RoundedRectangle(cornerRadius: 16, style: .continuous)
)
.overlay {
    RoundedRectangle(cornerRadius: 16, style: .continuous)
        .strokeBorder(.quaternary, lineWidth: 0.5)
}
.shadow(color: .black.opacity(0.08), radius: 12, y: 4)
```

**Key Points:**
- Always use `style: .continuous` for iOS squircle appearance
- Border overlay provides subtle definition
- Standardized shadow for consistent elevation

### Corner Radius System

All UI elements use **continuous corners** (squircles) instead of traditional rounded rectangles:

```swift
// ✅ CORRECT - Continuous corners (iOS native look)
RoundedRectangle(cornerRadius: 16, style: .continuous)

// ❌ WRONG - Mathematical rounded corners (older iOS)
RoundedRectangle(cornerRadius: 16)
```

#### Size Guidelines

| Element | Radius | Style |
|---------|--------|-------|
| Large cards (headers) | 20pt | .continuous |
| Standard containers | 16pt | .continuous |
| Small components | 12pt | .continuous |
| Buttons | 10pt | .continuous |
| Capsule badges | 6pt | Capsule() |
| Circles | — | Circle() |

### Spacing System (8pt Grid)

All spacing follows an 8pt grid for consistency and alignment:

```swift
enum AppleSpacing {
    static let tiny: CGFloat = 4          // Micro spacing
    static let compact: CGFloat = 8       // Default spacing
    static let small: CGFloat = 12        // Form sections
    static let standard: CGFloat = 16     // Standard margins
    static let comfortable: CGFloat = 20  // iPad margins
    static let large: CGFloat = 24        // Large sections
    static let extraLarge: CGFloat = 32   // Full-width spacing
    static let minTouchTarget: CGFloat = 44  // Button height
}
```

### Elevation System

Three elevation levels create visual hierarchy without complexity:

```swift
enum ElevationLevel {
    case flat        // z = 0 (no shadow)
    case low         // z = 4 (subtle)
    case medium      // z = 12 (standard)
    case high        // z = 20 (prominent)
}

// Implementation
.shadow(color: .black.opacity(0.08), radius: 12, y: 4)  // Medium
.shadow(color: .black.opacity(0.05), radius: 4, y: 2)   // Low
.shadow(color: .black.opacity(0.12), radius: 20, y: 8)  // High
```

**Shadow Consistency:**
- All shadows use black opacity (not colored shadows)
- Medium elevation (12pt radius, 0.08 opacity) is default
- Shadows create subtle depth, not harsh contrast

### SF Symbols & Icons

All SF Symbols use **hierarchical rendering** for visual consistency:

```swift
// ✅ CORRECT - Hierarchical rendering
Image(systemName: "person.circle.fill")
    .symbolRenderingMode(.hierarchical)
    .foregroundStyle(.blue)

// ❌ WRONG - No rendering mode
Image(systemName: "person.circle.fill")
    .foregroundColor(.blue)
```

#### Rendering Modes

| Mode | Use Case | Example |
|------|----------|---------|
| `.hierarchical` | Primary icons, UI controls | Dashboard cards, buttons |
| `.palette` | Multi-colored icons | Status indicators |
| `.multicolor` | System icons | Weather, battery |
| `.monochrome` | Subtle icons | Secondary actions |

#### Icon Sizing

| Context | Size | Weight |
|---------|------|--------|
| Tab bar | .subheadline | — |
| Navigation | .body | — |
| Buttons | .title2 | .semibold |
| Badges | .caption | — |
| Headers | .title | .bold |

### Typography Scale

The app uses SF Pro font family (system default) with semantic sizing:

```swift
// ✅ CORRECT - Semantic sizing
Text("Headline")
    .font(.system(.headline, design: .default, weight: .semibold))

// ❌ WRONG - Fixed sizing (not accessible)
Text("Headline")
    .font(.system(size: 17, weight: .semibold))
```

#### Typography Hierarchy

| Level | Use | Font Size | Weight | Example |
|-------|-----|-----------|--------|---------|
| Title | Page titles | .title2 | bold | Screen headers |
| Headline | Section headers | .headline | semibold | Card titles, labels |
| Body | Content | .body | regular | Description text |
| Subheadline | Secondary | .subheadline | regular | Dates, timestamps |
| Caption | Tertiary | .caption | medium | Hints, supplementary |
| Caption2 | Micro | .caption2 | medium | Minimal UI text |

### Color System

The app uses system colors with semantic meaning:

#### Semantic Colors

| Color | Meaning | Components |
|-------|---------|-----------|
| `.blue` | Primary action | Buttons, links |
| `.green` | Success, present | Checkmarks, badges |
| `.red` | Error, danger | Warnings, destructive actions |
| `.orange` | Warning, late | Caution states |
| `.purple` | Special, sick | Status badges |
| `.gray` | Disabled, holiday | Inactive states |
| `.primary` | Main text | Headlines, body text |
| `.secondary` | Supporting text | Labels, hints |
| `.tertiary` | Subtle text | Timestamps, secondary info |
| `.quaternary` | Minimal | Dividers, borders |

#### Dark Mode Support

All colors automatically adapt to light/dark mode:

```swift
// ✅ CORRECT - Adaptive colors
Text("Content")
    .foregroundStyle(.primary)  // Adapts automatically

// ❌ WRONG - Fixed colors
Text("Content")
    .foregroundColor(.black)  // Doesn't adapt to dark mode
```

## Component Patterns

### Cards (Glass Containers)

All cards use the standard glass container pattern:

**Large Cards (Headers, Prominent Content):**
```swift
VStack(spacing: 12) {
    // Content
}
.padding()
.background(
    .regularMaterial,
    in: RoundedRectangle(cornerRadius: 20, style: .continuous)
)
.overlay {
    RoundedRectangle(cornerRadius: 20, style: .continuous)
        .strokeBorder(.quaternary, lineWidth: 0.5)
}
.shadow(color: .black.opacity(0.08), radius: 12, y: 4)
```

**Standard Cards (Content Containers):**
```swift
VStack(spacing: 8) {
    // Content
}
.padding()
.background(
    .thinMaterial,
    in: RoundedRectangle(cornerRadius: 16, style: .continuous)
)
.overlay {
    RoundedRectangle(cornerRadius: 16, style: .continuous)
        .strokeBorder(.quaternary, lineWidth: 0.5)
}
.shadow(color: .black.opacity(0.08), radius: 12, y: 4)
```

### Lists & Forms

Forms use iOS native `List` with `.listStyle(.insetGrouped)`:

```swift
Form {
    Section(String(localized: "section.title")) {
        TextField("Field", text: $value)
        Picker("Pick", selection: $selected) {
            ForEach(options, id: \.self) { option in
                Text(option).tag(option)
            }
        }
    }
    .headerProminence(.increased)
}
.listStyle(.insetGrouped)
.scrollContentBackground(.hidden)
.background(.ultraThinMaterial)
```

**Why insetGrouped?**
- Native iOS appearance (matches Settings, Reminders, Calendar)
- Automatic spacing and grouping
- Reduces visual clutter
- Better accessibility

### Navigation

The app uses **TabView** for primary navigation (5+ main screens):

```swift
TabView {
    DashboardContent()
        .tabItem {
            Label("Dashboard", systemImage: "house.fill")
        }

    AttendanceContent()
        .tabItem {
            Label("Attendance", systemImage: "checkmark.circle.fill")
        }

    // ... more tabs
}
.tint(.blue)
```

**TabView Benefits:**
- Native iOS appearance
- Automatic safe area handling
- Bottom tab bar on iPhone, sidebar on iPad
- Familiar to all iOS users

### Sheets & Modals

Sheets use `.presentationDetents()` for native iOS behavior:

```swift
.sheet(isPresented: $isPresented) {
    FormView()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(.thinMaterial)
        .presentationCornerRadius(20)
}
```

**Sheet Behavior:**
- Half-height default (resizable to full)
- Drag indicator for affordance
- Glass background reveals scrolled content
- Continuous corners for cohesion

### Context Menus

Long-press actions appear on interactive elements:

```swift
HStack {
    Text(item.title)
    Spacer()
    Image(systemName: "chevron.right")
}
.contextMenu {
    Button {
        UIPasteboard.general.string = item.title
    } label: {
        Label("Copy", systemImage: "doc.on.doc")
    }

    Button(role: .destructive) {
        deleteItem()
    } label: {
        Label("Delete", systemImage: "trash")
    }
}
```

**Context Menu Guidelines:**
- Use for non-primary actions
- Keep to 2-4 most common actions
- Destructive actions last with red color
- Include copy/share for text content

### Buttons

Interactive buttons use semantic styling:

**Primary Buttons:**
```swift
Button("Create") {
    action()
}
.font(.system(.body, weight: .semibold))
.frame(maxWidth: .infinity)
.padding()
.background(Color.accentColor)
.foregroundStyle(.white)
.clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
```

**Secondary Buttons:**
```swift
Button("Cancel") {
    action()
}
.font(.system(.body, weight: .semibold))
.frame(maxWidth: .infinity)
.padding()
.background(.thinMaterial)
.clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
```

**Tertiary Buttons (Text Only):**
```swift
Button("Learn More") {
    action()
}
.font(.system(.body, weight: .semibold))
.foregroundStyle(.blue)
```

**Minimal Touch Target:** 44pt height/width for accessibility

## Localization

The app supports Arabic (RTL) and English (LTR) seamlessly:

```swift
// ✅ CORRECT - RTL-aware
HStack {
    Image(systemName: "chevron.right")
        .flipsForRightToLeftLayoutDirection(true)
    Text("Next")
}

// ❌ WRONG - RTL ignorant
HStack {
    Image(systemName: "chevron.right")
    Text("Next")
}
```

All text strings are in `Localizable.xcstrings` with translations.

## Accessibility (a11y)

All interactive elements have accessibility labels and hints:

```swift
Button {
    action()
} label: {
    Image(systemName: "person.fill")
}
.accessibilityLabel("Edit Profile")
.accessibilityHint("Opens profile editing form")
```

**Accessibility Checklist:**
- [ ] All buttons have labels
- [ ] All images have descriptions (or `.accessibilityHidden(true)` if decorative)
- [ ] Form fields have associated labels
- [ ] Color is not the only way to convey information
- [ ] Text has sufficient contrast (WCAG AA)
- [ ] Touch targets are 44pt minimum

## Animation & Transitions

SwiftUI animations use sensible defaults:

```swift
// ✅ CORRECT - Spring animation (feels natural)
withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
    isExpanded.toggle()
}

// ❌ WRONG - Linear animation (feels robotic)
withAnimation(.linear) {
    isExpanded.toggle()
}
```

**Animation Principles:**
- Use spring animations for natural motion
- Keep durations short (200-400ms)
- Don't animate everything (restraint > flash)
- Respect system reduced motion settings

## Dark Mode

All colors and materials automatically adapt to dark mode:

```swift
// ✅ CORRECT - Semantic colors adapt
.foregroundStyle(.primary)      // Black in light, white in dark
.background(.thinMaterial)      // Adapts to environment

// ❌ WRONG - Fixed colors
.foregroundColor(.black)        // Always black, unreadable in dark
```

Test dark mode with **Settings** → **Developer** → **Appearance** → **Dark**.

## Performance Guidelines

### Rendering

- Avoid `.onReceive` for frequent updates (use `.task` instead)
- Use `@State` for local state only
- Use `@Bindable` for ViewModel properties
- Prefer `ZStack` over `overlay` when possible

### Memory

- Don't load full-size images from network (use thumbnails)
- SwiftData handles cache automatically
- Avoid `ForEach` with complex computations
- Profile with Xcode Instruments

## File Organization

All view files follow consistent structure:

```swift
import SwiftUI

// MARK: - Main View
struct FeatureContent: View {
    var body: some View { ... }
}

// MARK: - Subcomponents
struct SubComponent: View {
    var body: some View { ... }
}

// MARK: - Preview
#Preview { ... }
```

## Testing Design Consistency

Before shipping, verify:

1. **Visual**: Screenshots in light & dark mode
2. **Interaction**: Tap all buttons, test context menus
3. **Accessibility**: Use VoiceOver to navigate
4. **Performance**: Profile with Instruments
5. **iPad**: Test landscape and split-view

## References

- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [iOS Design Patterns](https://developer.apple.com/design/resources/)
- [SF Symbols](https://developer.apple.com/sf-symbols/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Accessible Design](https://www.apple.com/accessibility/)
