import SwiftUI

// MARK: - ComingSoonView
//
// Placeholder shown when a home-grid tile maps to a feature module that
// hasn't been ported yet. Mirrors the same look as the other sheet content
// (NavigationStack + inset list) so the UX feels intentional rather than
// broken.

struct ComingSoonView: View {
    let sheet: HomeSheet
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: sheet.systemImage)
                .font(.system(size: 56, weight: .semibold))
                .foregroundStyle(.tint)
                .padding(.top, 32)

            Text(sheet.title)
                .font(.title2.weight(.bold))

            Text("home.comingSoon.subtitle")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(Text(sheet.title))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "home.comingSoon.dismiss")) { dismiss() }
            }
        }
    }
}

private extension HomeSheet {
    /// User-facing title — matches the home-tile label so the sheet reads
    /// as a continuation of the tap.
    var title: LocalizedStringResource {
        switch self {
        case .announcements: "home.action.announcements"
        case .events:        "home.action.events"
        case .subjects:      "dashboard.action.subjects"
        case .library:       "home.action.library"
        case .stream:        "home.action.stream"
        case .admission:     "home.action.admission"
        case .fees:          "dashboard.action.fees"
        case .exams:         "home.action.exams"
        case .assignments:   "home.action.assignments"
        case .reportCards:   "home.action.reportCards"
        case .idCard:        "home.action.idCard"
        }
    }

    var systemImage: String {
        switch self {
        case .announcements: "megaphone.fill"
        case .events:        "star.fill"
        case .subjects:      "book.closed.fill"
        case .library:       "books.vertical.fill"
        case .stream:        "play.rectangle.fill"
        case .admission:     "person.badge.plus.fill"
        case .fees:          "dollarsign.circle.fill"
        case .exams:         "graduationcap.fill"
        case .assignments:   "doc.text.fill"
        case .reportCards:   "chart.bar.fill"
        case .idCard:        "person.text.rectangle.fill"
        }
    }
}

#Preview { NavigationStack { ComingSoonView(sheet: .events) } }
