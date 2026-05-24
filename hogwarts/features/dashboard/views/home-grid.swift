import SwiftUI

// MARK: - HomeGrid
// Source: Figma iOS 26 — Home Screen (node 110-378)
// Parity: kotlin-app/feature/dashboard/.../home-grid.kt
//
// 4-column iOS home-screen grid of `HWBadgedAppIcon` tiles.
// Spacing: 14pt column gap, 20pt row gap, 24pt horizontal/top inset.

struct HomeGrid: View {
    let tiles: [HomeTileSpec]
    var labelColor: Color = .white

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 14, alignment: .top),
        count: 4
    )

    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
            ForEach(tiles) { tile in
                HWBadgedAppIcon(
                    label: String(localized: tile.label),
                    iconName: tile.assetName,
                    systemImage: tile.systemImage,
                    tint: tile.tint,
                    labelColor: labelColor,
                    count: tile.badgeCount,
                    action: tile.action
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }
}

#Preview("Home grid — student") {
    ZStack {
        LinearGradient(
            colors: [.accentBlue.opacity(0.7), .accentPurple.opacity(0.6)],
            startPoint: .top, endPoint: .bottom
        )
        .ignoresSafeArea()

        ScrollView {
            HomeGrid(tiles: buildHomeTiles(
                role: .student,
                counts: HomeTileBadgeCounts(
                    pendingAttendance: 1,
                    upcomingExams: 3,
                    todayClasses: 5,
                    unreadMessages: 12,
                    unreadNotifications: 4,
                    pendingAssignments: 2
                ),
                go: { _ in }
            ))
        }
    }
}

#Preview("Home grid — RTL admin") {
    ZStack {
        LinearGradient(
            colors: [.accentBlue.opacity(0.7), .accentPurple.opacity(0.6)],
            startPoint: .top, endPoint: .bottom
        )
        .ignoresSafeArea()

        ScrollView {
            HomeGrid(tiles: buildHomeTiles(
                role: .admin,
                counts: HomeTileBadgeCounts(unreadNotifications: 7, pendingAssignments: 3),
                go: { _ in }
            ))
        }
    }
    .environment(\.layoutDirection, .rightToLeft)
}
