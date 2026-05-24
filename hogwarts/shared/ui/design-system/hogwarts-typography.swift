import SwiftUI

// MARK: - Hogwarts Typography
// Source of truth: Figma iOS 26 kit — SF Pro type scale
// Cross-platform parity: kotlin-app/core/designsystem/theme/typography.kt
//
// Figma extracted values:
//   Large Title/Emphasized: 34px, Bold (700), line-height 41, tracking +0.4
//   Headline/Regular:       17px, Semibold (590), line-height 22, tracking -0.43
//   Body/Regular:           17px, Regular (400), line-height 22, tracking -0.43
//   Subheadline/Regular:    15px, Regular (400), line-height 20, tracking -0.23
//
// SwiftUI's built-in Font.TextStyle matches these exactly — SF Pro is the system font.
// No custom fonts needed. SF Arabic activates automatically for RTL locales.

// MARK: - Typography View Modifiers

extension View {
    /// Page title — Figma: Large Title/Emphasized
    /// 34px Bold, line-height 41, tracking +0.4
    func hwLargeTitle() -> some View {
        self.font(.largeTitle.bold())
    }

    /// Section title — maps to Compose headlineMedium
    func hwTitle() -> some View {
        self.font(.title2.weight(.semibold))
    }

    /// Card/row title — Figma: Headline/Regular
    /// 17px Semibold (590), line-height 22, tracking -0.43
    func hwHeadline() -> some View {
        self.font(.headline)
    }

    /// Body text — Figma: Body/Regular
    /// 17px Regular (400), line-height 22, tracking -0.43
    func hwBody() -> some View {
        self.font(.body)
    }

    /// Subtitle/detail — Figma: Subheadline/Regular
    /// 15px Regular (400), line-height 20, tracking -0.23
    func hwSubheadline() -> some View {
        self.font(.subheadline)
            .foregroundStyle(.secondary)
    }

    /// Caption — small secondary text
    func hwCaption() -> some View {
        self.font(.caption)
            .foregroundStyle(.secondary)
    }

    /// Footnote — tiny tertiary text
    func hwFootnote() -> some View {
        self.font(.caption2)
            .foregroundStyle(.tertiary)
    }

    /// Button label — Figma: 17px Medium
    func hwButtonLabel() -> some View {
        self.font(.body.weight(.medium))
    }
}

// MARK: - Semantic Type Scale (Font values)

enum HWFont {
    /// 34px Bold — page titles, navigation large title
    static let largeTitle: Font = .largeTitle.bold()

    /// 22px Bold — section headers
    static let title: Font = .title2.weight(.semibold)

    /// 17px Semibold — card titles, row titles
    static let headline: Font = .headline

    /// 17px Regular — body copy
    static let body: Font = .body

    /// 15px Regular — subtitles, secondary text
    static let subheadline: Font = .subheadline

    /// 12px Regular — captions, timestamps
    static let caption: Font = .caption

    /// 11px Regular — footnotes, fine print
    static let footnote: Font = .caption2

    /// 17px Medium — button labels
    static let button: Font = .body.weight(.medium)
}
