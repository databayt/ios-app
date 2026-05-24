import SwiftUI

// MARK: - Hogwarts Semantic Colors
// Source of truth: Figma iOS 26 kit (WJPT23xMx4B6oXrCavmHbQ)
// Cross-platform parity: kotlin-app/core/designsystem/theme/color.kt

extension Color {

    // MARK: - Primary Brand

    /// Hogwarts primary blue — #0062D9
    static let hogwartsPrimary = Color(red: 0, green: 0.384, blue: 0.851)

    /// Light variant — #409CFF
    static let hogwartsPrimaryLight = Color(red: 0.251, green: 0.612, blue: 1)

    /// Dark variant — #004DB3
    static let hogwartsPrimaryDark = Color(red: 0, green: 0.302, blue: 0.702)

    /// On primary — white text on primary surfaces
    static let hogwartsOnPrimary = Color.white

    // MARK: - Secondary Brand

    /// Gold/Amber — #D97706
    static let hogwartsSecondary = Color(red: 0.851, green: 0.467, blue: 0.024)

    /// Light variant — #F59E0B
    static let hogwartsSecondaryLight = Color(red: 0.961, green: 0.620, blue: 0.043)

    /// On secondary — white text
    static let hogwartsOnSecondary = Color.white

    // MARK: - Tertiary Brand

    /// Emerald — #059669
    static let hogwartsTertiary = Color(red: 0.020, green: 0.588, blue: 0.412)

    /// Light variant — #10B981
    static let hogwartsTertiaryLight = Color(red: 0.063, green: 0.725, blue: 0.506)

    /// On tertiary — white text
    static let hogwartsOnTertiary = Color.white

    // MARK: - Error

    /// Error red — #DC2626
    static let hogwartsError = Color(red: 0.863, green: 0.149, blue: 0.149)

    /// Error light background — #FEE2E2
    static let hogwartsErrorLight = Color(red: 0.996, green: 0.886, blue: 0.886)

    // MARK: - Status Colors

    static let statusSuccess = Color(red: 0.063, green: 0.725, blue: 0.506)   // #10B981
    static let statusWarning = Color(red: 0.961, green: 0.620, blue: 0.043)   // #F59E0B
    static let statusError = Color(red: 0.937, green: 0.267, blue: 0.267)     // #EF4444
    static let statusInfo = Color(red: 0.231, green: 0.510, blue: 0.965)      // #3B82F6

    // MARK: - Form Message Colors (matching web + Android)

    /// Error message background — 15% opacity red
    static let formErrorBackground = Color(red: 0.863, green: 0.149, blue: 0.149).opacity(0.15)

    /// Error message text — solid red
    static let formErrorForeground = Color(red: 0.863, green: 0.149, blue: 0.149)

    /// Success message background — 15% opacity emerald
    static let formSuccessBackground = Color(red: 0.063, green: 0.725, blue: 0.506).opacity(0.15)

    /// Success message text — solid emerald
    static let formSuccessForeground = Color(red: 0.063, green: 0.725, blue: 0.506)

    // MARK: - Attendance

    static let attendancePresent = Color(red: 0.063, green: 0.725, blue: 0.506)   // #10B981
    static let attendanceAbsent = Color(red: 0.937, green: 0.267, blue: 0.267)    // #EF4444
    static let attendanceLate = Color(red: 0.961, green: 0.620, blue: 0.043)      // #F59E0B
    static let attendanceExcused = Color(red: 0.388, green: 0.400, blue: 0.945)   // #6366F1

    // MARK: - Grades

    static let gradeExcellent = Color(red: 0.063, green: 0.725, blue: 0.506)  // A — #10B981
    static let gradeGood = Color(red: 0.231, green: 0.510, blue: 0.965)       // B — #3B82F6
    static let gradeAverage = Color(red: 0.961, green: 0.620, blue: 0.043)    // C — #F59E0B
    static let gradeBelowAverage = Color(red: 0.976, green: 0.451, blue: 0.086) // D — #F97316
    static let gradeFail = Color(red: 0.937, green: 0.267, blue: 0.267)       // F — #EF4444
}

// MARK: - Figma iOS 26 System Token Aliases
// These map Figma variable names to UIKit system equivalents.
// Use these when you need the exact Figma token by name.

extension Color {
    /// Figma: backgrounds/grouped/primary → #F2F2F7
    static let groupedBackground = Color(uiColor: .systemGroupedBackground)

    /// Figma: backgrounds/grouped/secondary → #FFFFFF
    static let groupedSecondaryBackground = Color(uiColor: .secondarySystemGroupedBackground)

    /// Figma: fills/tertiary → rgba(118,118,128,0.12)
    static let fillTertiary = Color(uiColor: .tertiarySystemFill)

    /// Figma: fills/quaternary → rgba(116,116,128,0.08)
    static let fillQuaternary = Color(uiColor: .quaternarySystemFill)

    /// Figma: separators/vibrant → #E6E6E6
    static let separatorVibrant = Color(uiColor: .separator)
}

// MARK: - Figma iOS 26 Accent Aliases
// Figma uses these exact names in the design kit.
// Map to Apple system colors which are identical.

extension Color {
    /// Figma: accents/blue → #0088FF (maps to iOS system blue)
    static let accentBlue = Color(uiColor: .systemBlue)

    /// Figma: accents/green → #34C759
    static let accentGreen = Color(uiColor: .systemGreen)

    /// Figma: accents/orange → #FF9500
    static let accentOrange = Color(uiColor: .systemOrange)

    /// Figma: accents/red → #FF3B30
    static let accentRed = Color(uiColor: .systemRed)

    /// Figma: accents/purple → #AF52DE
    static let accentPurple = Color(uiColor: .systemPurple)

    /// Figma: accents/teal → #5AC8FA
    static let accentTeal = Color(uiColor: .systemTeal)

    /// Figma: accents/indigo → #5856D6
    static let accentIndigo = Color(uiColor: .systemIndigo)

    /// Figma: accents/pink → #FF2D55
    static let accentPink = Color(uiColor: .systemPink)

    /// Figma: accents/yellow → #FFCC00
    static let accentYellow = Color(uiColor: .systemYellow)
}

// MARK: - Surfaces — Light + Dark (parity with kotlin color.kt:46-59)

extension Color {
    /// Light surface background — #F2F2F7
    static let hogwartsBackground = Color(red: 0.949, green: 0.949, blue: 0.969)

    /// Light surface — #FFFFFF
    static let hogwartsSurface = Color.white

    /// Light surface variant — #E5E5EA
    static let hogwartsSurfaceVariant = Color(red: 0.898, green: 0.898, blue: 0.918)

    /// Dark background — #000000
    static let hogwartsBackgroundDark = Color.black

    /// Dark surface — #1C1C1E
    static let hogwartsSurfaceDark = Color(red: 0.110, green: 0.110, blue: 0.118)

    /// Dark surface variant — #2C2C2E
    static let hogwartsSurfaceVariantDark = Color(red: 0.173, green: 0.173, blue: 0.180)

    /// On-background light — #000000
    static let hogwartsOnBackground = Color.black

    /// On-surface light — #1C1C1E
    static let hogwartsOnSurface = Color(red: 0.110, green: 0.110, blue: 0.118)

    /// On-surface-variant light — #8E8E93
    static let hogwartsOnSurfaceVariant = Color(red: 0.557, green: 0.557, blue: 0.576)

    /// On-background dark — #FFFFFF
    static let hogwartsOnBackgroundDark = Color.white

    /// On-surface dark — #E5E5EA
    static let hogwartsOnSurfaceDark = Color(red: 0.898, green: 0.898, blue: 0.918)

    /// On-surface-variant dark — #8E8E93
    static let hogwartsOnSurfaceVariantDark = Color(red: 0.557, green: 0.557, blue: 0.576)

    /// Outline (iOS opaqueSeparator) light — #C6C6C8
    static let hogwartsOutline = Color(red: 0.776, green: 0.776, blue: 0.784)

    /// Outline dark — #38383A
    static let hogwartsOutlineDark = Color(red: 0.220, green: 0.220, blue: 0.227)
}

// MARK: - Muted + Divider (parity with kotlin color.kt:80-87)

extension Color {
    /// Muted foreground (iOS systemGray) — #8E8E93
    static let mutedForeground = Color(red: 0.557, green: 0.557, blue: 0.576)

    /// Muted foreground dark — same hex, kept distinct for theming hooks
    static let mutedForegroundDark = Color(red: 0.557, green: 0.557, blue: 0.576)

    /// Muted background light (systemGray5) — #E5E5EA
    static let mutedBackground = Color(red: 0.898, green: 0.898, blue: 0.918)

    /// Muted background dark — #2C2C2E
    static let mutedBackgroundDark = Color(red: 0.173, green: 0.173, blue: 0.180)

    /// Divider light — #C6C6C8
    static let dividerColor = Color(red: 0.776, green: 0.776, blue: 0.784)

    /// Divider dark — #38383A
    static let dividerColorDark = Color(red: 0.220, green: 0.220, blue: 0.227)
}

// MARK: - Apple system gray scale (parity with kotlin color.kt:103-108)

extension Color {
    /// systemGray — #8E8E93
    static let appleGray1 = Color(uiColor: .systemGray)

    /// systemGray2 — #AEAEB2
    static let appleGray2 = Color(uiColor: .systemGray2)

    /// systemGray3 — #C7C7CC
    static let appleGray3 = Color(uiColor: .systemGray3)

    /// systemGray4 — #D1D1D6
    static let appleGray4 = Color(uiColor: .systemGray4)

    /// systemGray5 — #E5E5EA
    static let appleGray5 = Color(uiColor: .systemGray5)

    /// systemGray6 — #F2F2F7
    static let appleGray6 = Color(uiColor: .systemGray6)
}

// MARK: - Glass material backgrounds (parity with kotlin color.kt:121-123)

extension Color {
    /// Glass light — 90% white over content
    static let glassLightBackground = Color.white.opacity(0.9)

    /// Glass dark — 25% white over content
    static let glassDarkBackground = Color.white.opacity(0.25)
}
