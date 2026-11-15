import SwiftUI

/// Dashboard entry to the live-class block: a card that pushes `LiveHomeContent` onto the
/// dashboard's NavigationStack. Used by the teacher and student dashboards.
struct LiveEntryCard: View {
    var body: some View {
        NavigationLink {
            LiveHomeContent()
        } label: {
            DashboardCard(
                title: String(localized: "live.entry.title"),
                systemImage: "video"
            ) {
                Text(String(localized: "live.entry.subtitle"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
    }
}
