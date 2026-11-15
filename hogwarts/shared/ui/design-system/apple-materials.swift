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
        let shadow = level.shadow
        return self.shadow(color: shadow.color, radius: shadow.radius, y: shadow.y)
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

// MARK: - Color Extensions

extension Color {
    /// Apple's accent blue
    static let appleBlue = Color(red: 0, green: 0.478, blue: 1)
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

// MARK: - Shape + row-height tokens (Apple iOS 26 kit)

/// Corner radii used by atoms.
enum HWShape {
    static let card: CGFloat = 26
    static let button: CGFloat = 16
    static let textField: CGFloat = 12
}

/// Row heights used by atoms.
enum HWRowHeight {
    static let minTouchTarget: CGFloat = 44
    static let standard: CGFloat = 44
    static let subtitle: CGFloat = 62
}
