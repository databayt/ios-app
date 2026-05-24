import SwiftUI

// MARK: - HomeTileSpec
// Source: Figma iOS 26 — Home Screen tiles
// Parity: kotlin-app/feature/dashboard/.../home-tile-spec.kt
//
// One tile on the iOS-style 4×4 home grid. When `assetName` is non-nil the
// tile renders a full-bleed Figma-authored drawable (color background +
// glyph baked in); otherwise it falls back to the SF Symbol on a glossy
// gradient tinted with `tint`.

struct HomeTileSpec: Identifiable {
    let id = UUID()
    /// Localized label shown beneath the tile.
    let label: LocalizedStringResource
    /// Full-bleed asset (e.g. `tile-stream`). Wins over SF Symbol.
    var assetName: String?
    /// SF Symbol fallback when no asset is provided.
    let systemImage: String
    /// Gradient tint when no asset is provided.
    let tint: Color
    /// Unread / count badge — `0` hides the badge.
    var badgeCount: Int = 0
    let action: () -> Void
}

// MARK: - Destinations

/// Where a home-grid tile sends the user. Tiles for existing tabs flip the
/// `TabView` selection; tiles for newer features open as a sheet over the
/// home grid until the proper Coordinator/Router lands.
enum HomeDestination {
    case tab(AppTab)
    case sheet(HomeSheet)
}

/// Sheet routes presented from the home grid. Each new feature module that
/// doesn't have a top-level tab gets a case here and a corresponding view
/// in `HomeScreen.sheetContent(for:)`.
enum HomeSheet: String, Identifiable, Hashable {
    case announcements
    case events
    case subjects
    case library
    case stream
    case admission
    case fees
    case exams
    case assignments
    case reportCards
    case idCard
    /// Role-specific entry points — only added to the tile catalog when the
    /// active role matches.
    case guardianChildren
    case teacherWorkspace
    case adminConsole

    var id: String { rawValue }
}

// MARK: - Tile catalog

/// Builds the role-aware tile list for the home grid. Mirrors Android's
/// `buildHomeTiles(...)` — same ordering, same colors, same badge wiring.
///
/// - Parameters:
///   - role: drives which tiles are visible (admins see Students, etc.)
///   - counts: badge counts injected from the home view model
///   - go: callback that handles the tapped destination — either flipping
///         the tab or presenting a sheet. Future PRs replace this with a
///         `RootCoordinator.go(to:)` once we modularize.
@MainActor
func buildHomeTiles(
    role: UserRole,
    counts: HomeTileBadgeCounts,
    go: @escaping (HomeDestination) -> Void
) -> [HomeTileSpec] {
    var tiles: [HomeTileSpec] = []

    if role.isAdmin {
        tiles.append(HomeTileSpec(
            label: "dashboard.action.students",
            systemImage: "person.2.fill",
            tint: .accentBlue,
            action: { go(.tab(.students)) }
        ))
        tiles.append(HomeTileSpec(
            label: "home.action.adminConsole",
            systemImage: "shield.fill",
            tint: .accentRed,
            action: { go(.sheet(.adminConsole)) }
        ))
    }
    if role == .teacher {
        tiles.append(HomeTileSpec(
            label: "home.action.teacherWorkspace",
            systemImage: "rectangle.3.group.bubble.fill",
            tint: .accentPurple,
            action: { go(.sheet(.teacherWorkspace)) }
        ))
    }
    if role == .guardian {
        tiles.append(HomeTileSpec(
            label: "home.action.children",
            systemImage: "figure.child.holdinghand",
            tint: .accentGreen,
            action: { go(.sheet(.guardianChildren)) }
        ))
    }

    tiles.append(contentsOf: [
        HomeTileSpec(
            label: "dashboard.action.attendance",
            systemImage: "checkmark.circle.fill",
            tint: .accentGreen,
            badgeCount: counts.pendingAttendance,
            action: { go(.tab(.dashboard)) }
        ),
        HomeTileSpec(
            label: "dashboard.action.grades",
            systemImage: "chart.bar.fill",
            tint: .accentOrange,
            badgeCount: counts.upcomingExams,
            action: { go(.sheet(.reportCards)) }
        ),
        HomeTileSpec(
            label: "dashboard.action.fees",
            assetName: "tile-wallet",
            systemImage: "dollarsign.circle.fill",
            tint: .accentGreen,
            action: { go(.sheet(.fees)) }
        ),
        HomeTileSpec(
            label: "dashboard.action.schedule",
            systemImage: "calendar",
            tint: .accentRed,
            badgeCount: counts.todayClasses,
            action: { go(.tab(.schedule)) }
        ),
        HomeTileSpec(
            label: "dashboard.action.messages",
            assetName: "tile-message",
            systemImage: "bubble.left.and.bubble.right.fill",
            tint: .accentGreen,
            badgeCount: counts.unreadMessages,
            action: { go(.tab(.messages)) }
        ),
        HomeTileSpec(
            label: "home.action.stream",
            assetName: "tile-stream",
            systemImage: "play.rectangle.fill",
            tint: .accentPurple,
            action: { go(.sheet(.stream)) }
        ),
        HomeTileSpec(
            label: "dashboard.action.subjects",
            assetName: "tile-subject",
            systemImage: "book.closed.fill",
            tint: .accentBlue,
            action: { go(.sheet(.subjects)) }
        ),
        HomeTileSpec(
            label: "dashboard.tab.settings",
            assetName: "tile-setting",
            systemImage: "gearshape.fill",
            tint: .appleGray1,
            action: { go(.tab(.profile)) }
        ),
        HomeTileSpec(
            label: "home.action.notifications",
            systemImage: "bell.fill",
            tint: .accentRed,
            badgeCount: counts.unreadNotifications,
            action: { go(.tab(.notifications)) }
        ),
        HomeTileSpec(
            label: "home.action.exams",
            systemImage: "graduationcap.fill",
            tint: .accentIndigo,
            badgeCount: counts.upcomingExams,
            action: { go(.sheet(.exams)) }
        ),
        HomeTileSpec(
            label: "home.action.assignments",
            systemImage: "doc.text.fill",
            tint: .accentOrange,
            badgeCount: counts.pendingAssignments,
            action: { go(.sheet(.assignments)) }
        ),
        HomeTileSpec(
            label: "home.action.library",
            systemImage: "books.vertical.fill",
            tint: .accentYellow,
            action: { go(.sheet(.library)) }
        ),
        HomeTileSpec(
            label: "home.action.events",
            systemImage: "star.fill",
            tint: .accentPink,
            action: { go(.sheet(.events)) }
        ),
        HomeTileSpec(
            label: "home.action.announcements",
            systemImage: "megaphone.fill",
            tint: .accentRed,
            action: { go(.sheet(.announcements)) }
        ),
        HomeTileSpec(
            label: "home.action.profile",
            systemImage: "person.crop.circle.fill",
            tint: .appleGray1,
            action: { go(.tab(.profile)) }
        )
    ])

    return tiles
}

/// Badge counts surfaced on the home grid tiles.
struct HomeTileBadgeCounts: Equatable {
    var pendingAttendance: Int = 0
    var upcomingExams: Int = 0
    var todayClasses: Int = 0
    var unreadMessages: Int = 0
    var unreadNotifications: Int = 0
    var pendingAssignments: Int = 0

    static let zero = HomeTileBadgeCounts()
}
