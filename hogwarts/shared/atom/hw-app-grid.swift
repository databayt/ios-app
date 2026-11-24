import SwiftUI

// MARK: - App tile grid
//
// The phone's app drawer: four columns of rounded tiles, the way Android's
// `AppTileGrid` (core/designsystem/kit/app-tile-grid.kt) lays them out, drawn
// with the iOS 26 kit's continuous corners and semantic tints.

struct AppTileItem: Identifiable, Hashable {
    let key: String
    let titleKey: String
    let systemImage: String
    let tint: Color
    let route: AppRoute

    var id: String { key }
}

struct AppTileGrid: View {
    let items: [AppTileItem]
    let onOpen: (AppTileItem) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12, alignment: .top), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 18) {
            ForEach(items) { item in
                Button {
                    onOpen(item)
                } label: {
                    VStack(spacing: 6) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [item.tint.opacity(0.95), item.tint.opacity(0.72)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 56, height: 56)
                                .shadow(color: item.tint.opacity(0.28), radius: 8, y: 4)

                            Image(systemName: item.systemImage)
                                .font(.system(size: 24, weight: .semibold))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.white)
                        }

                        Text(LocalizedStringKey(item.titleKey))
                            .font(.caption2)
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text(LocalizedStringKey(item.titleKey)))
            }
        }
    }
}

/// The tiles every role sees, then the ones its role adds.
enum HomeTiles {
    static func items(for role: UserRole) -> [AppTileItem] {
        var items: [AppTileItem] = [
            tile("lumos", "nav.lumos", "sparkles", .hogwartsPrimary, .lumosHome),
            tile("live", "nav.live", "video.badge.waveform", .red, .live),
            tile("subjects", "nav.subjects", "book.closed", .hogwartsTertiary, .subjects),
            tile("library", "nav.library", "books.vertical", .orange, .library),
            tile("exams", "nav.exams", "checkmark.seal", .indigo, .exams),
            tile("attendance", "nav.attendance", "person.badge.clock", .teal, .attendance),
            tile("grades", "nav.grades", "chart.bar.doc.horizontal", .blue, .grades),
            tile("timetable", "nav.timetable", "calendar", .purple, .timetable),
            tile("fees", "nav.finance", "creditcard", .green, .fees),
            tile("reportCards", "nav.reportCards", "doc.text.magnifyingglass", .cyan, .reportCards),
            tile("events", "nav.events", "calendar.badge.clock", .pink, .events),
            tile("announcements", "nav.announcements", "megaphone", .yellow, .announcements),
            tile("messages", "nav.messages", "bubble.left.and.bubble.right", .mint, .messages),
            tile("idCard", "nav.idCard", "person.text.rectangle", .brown, .idCard),
        ]

        switch role {
        case .student:
            items.append(tile("quizGame", "nav.quizGame", "gamecontroller", .purple, .quizGame))
        case .guardian:
            // A guardian reads their children's subjects through the child, not
            // through the school-wide catalogue the web hides from them.
            items.removeAll { $0.key == "subjects" }
            items.append(tile("children", "nav.children", "figure.2.and.child.holdinghands", .teal, .guardianChildren))
        case .teacher:
            items.insert(tile("teacher", "nav.teacher", "person.3", .indigo, .teacher), at: 5)
            items.append(tile("students", "nav.students", "person.2", .blue, .students))
            items.append(tile("lessons", "nav.assignments", "list.bullet.rectangle", .orange, .lessons))
        case .admin, .developer:
            items.insert(tile("admin", "nav.school", "building.columns", .blue, .admin), at: 0)
            items.append(tile("students", "nav.students", "person.2", .blue, .students))
            items.append(tile("staff", "nav.teachers", "person.text.rectangle", .indigo, .adminStaff))
            items.append(tile("classes", "nav.classrooms", "rectangle.3.group", .teal, .adminClasses))
            items.append(tile("admission", "nav.admission", "tray.and.arrow.down", .orange, .admission))
            items.append(tile("lessons", "nav.assignments", "list.bullet.rectangle", .purple, .lessons))
        case .staff, .accountant:
            items.append(tile("students", "nav.students", "person.2", .blue, .students))
            items.append(tile("admission", "nav.admission", "tray.and.arrow.down", .orange, .admission))
        case .user:
            break
        }

        return items
    }

    private static func tile(
        _ key: String,
        _ titleKey: String,
        _ systemImage: String,
        _ tint: Color,
        _ route: AppRoute
    ) -> AppTileItem {
        AppTileItem(key: key, titleKey: titleKey, systemImage: systemImage, tint: tint, route: route)
    }
}
