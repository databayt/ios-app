import SwiftUI

// MARK: - Material Modifiers

extension View {
    /// Liquid Glass card with iOS 26 aesthetic
    /// - Parameters:
    ///   - cornerRadius: Corner radius for the glass effect (default: 20)
    ///   - material: Material type (default: .thinMaterial)
    func liquidGlassCard(
        cornerRadius: CGFloat = 20,
        material: Material = .thinMaterial
    ) -> some View {
        self
            .background(
                material,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(.quaternary, lineWidth: 0.5)
            }
            .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
    }

    /// Ultra-thin material for overlays and lightweight glass effects
    /// - Parameter cornerRadius: Corner radius for the overlay (default: 16)
    func glassOverlay(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
    }

    /// Regular material for standard containers
    /// - Parameter cornerRadius: Corner radius (default: 16)
    func glassContainer(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(
                .regularMaterial,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(.quaternary.opacity(0.5), lineWidth: 0.5)
            }
    }

    /// Thick material for prominent surfaces
    /// - Parameter cornerRadius: Corner radius (default: 16)
    func glassPanel(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(
                .thickMaterial,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(.quaternary.opacity(0.3), lineWidth: 0.5)
            }
    }

    /// Continuous corners (squircle) - Apple's preferred corner style
    /// - Parameter radius: Radius for the squircle (default: 16)
    func continuousCorners(_ radius: CGFloat = 16) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

// MARK: - Elevation Styles

enum ElevationLevel {
    case flat
    case low
    case medium
    case high

    var shadow: (color: Color, radius: CGFloat, y: CGFloat) {
        switch self {
        case .flat:
            return (.clear, 0, 0)
        case .low:
            return (.black.opacity(0.05), 4, 2)
        case .medium:
            return (.black.opacity(0.08), 12, 4)
        case .high:
            return (.black.opacity(0.12), 20, 8)
        }
    }
}

extension View {
    /// Apply elevation shadow to any view
    /// - Parameter level: Elevation level (flat, low, medium, high)
    func elevation(_ level: ElevationLevel) -> some View {
        let s = level.shadow
        return self.shadow(color: s.color, radius: s.radius, y: s.y)
    }
}

// MARK: - Typography Scale

extension View {
    /// Apple headline style - semibold rounded design
    func appleHeadline() -> some View {
        self.font(.system(.headline, design: .rounded, weight: .semibold))
    }

    /// Apple title style - bold rounded design
    func appleTitle() -> some View {
        self.font(.system(.title2, design: .rounded, weight: .bold))
    }

    /// Apple body style - standard default font
    func appleBody() -> some View {
        self.font(.system(.body, design: .default, weight: .regular))
    }

    /// Apple caption style - small secondary text
    func appleCaption() -> some View {
        self.font(.system(.caption, design: .default, weight: .medium))
            .foregroundStyle(.secondary)
    }

    /// Apple large title - for section headers
    func appleLargeTitle() -> some View {
        self.font(.system(.largeTitle, design: .rounded, weight: .bold))
    }

    /// Apple footnote style - tiny secondary text
    func appleFootnote() -> some View {
        self.font(.system(.caption2, design: .default, weight: .regular))
            .foregroundStyle(.secondary)
    }
}

// MARK: - Liquid Glass Toolbar (iOS 26)
// Source: Figma iOS 26 kit — Toolbar - Top - iPhone (node 1:3049)
// Triple-blend: rgba(255,255,255,0.65) + #ddd color-burn + #f7f7f7 darken
// Shadow: 0px 8px 40px rgba(0,0,0,0.12), Corner: capsule (296px)

extension View {
    /// iOS 26 liquid glass toolbar button — capsule with frosted glass
    func liquidGlassToolbar() -> some View {
        self
            .background(
                .thinMaterial,
                in: Capsule()
            )
            .overlay {
                Capsule()
                    .strokeBorder(.quaternary.opacity(0.5), lineWidth: 0.5)
            }
            .shadow(color: .black.opacity(0.12), radius: 20, y: 4)
    }
}

// MARK: - Shapes (from Figma iOS 26 kit)

enum HWShape {
    /// Grouped table / card — Figma: 26px
    static let card: CGFloat = 26

    /// Small card — 16px
    static let smallCard: CGFloat = 16

    /// Button — Figma: 12px continuous
    static let button: CGFloat = 12

    /// Text field — 12px continuous
    static let textField: CGFloat = 12

    /// Chip / pill — 8px
    static let chip: CGFloat = 8

    /// Sheet top corners — 20px
    static let sheet: CGFloat = 20

    /// List row — 12px
    static let listRow: CGFloat = 12
}

// MARK: - Row Heights (from Figma List component)

enum HWRowHeight {
    /// Standard row — Figma: 52px
    static let standard: CGFloat = 52

    /// Subtitle/image row — Figma: 68px
    static let subtitle: CGFloat = 68

    /// Minimum touch target — Apple HIG: 44px
    static let minTouchTarget: CGFloat = 44
}

// MARK: - Background Modifiers

extension View {
    /// Apply adaptive background that respects light/dark mode
    /// - Parameters:
    ///   - material: Material type for glass effect
    ///   - fallbackColor: Solid color fallback if material unavailable
    func adaptiveBackground(
        material: Material = .thinMaterial,
        fallbackColor: Color = .gray.opacity(0.1)
    ) -> some View {
        self
            .background(
                material,
                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
            )
    }
}
