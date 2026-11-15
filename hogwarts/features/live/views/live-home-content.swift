import SwiftUI

/// `/live` — live now, then upcoming. Pull to refresh. Simplified from Android `live-home-screen.kt`
/// to a native inset-grouped List.
struct LiveHomeContent: View {
    @State private var viewModel = LiveHomeViewModel()

    var body: some View {
        List {
            if let landing = viewModel.landing {
                content(landing)
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 160)
                    .listRowBackground(Color.clear)
            } else if let error = viewModel.error {
                Text(error)
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(String(localized: "live.home.title"))
        .navigationBarTitleDisplayMode(.inline)
        .refreshable { await viewModel.load() }
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private func content(_ landing: LiveLandingResponse) -> some View {
        if landing.live.isEmpty && landing.upcoming.isEmpty && landing.catchUp.isEmpty {
            Section {
                VStack(spacing: 6) {
                    Text(String(localized: "live.home.empty.title")).font(.headline)
                    Text(String(localized: "live.home.empty.description"))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            }
        }
        if !landing.live.isEmpty {
            Section(String(localized: "live.home.liveNow")) {
                ForEach(landing.live) { row($0, viewer: landing.viewer) }
            }
        }
        if !landing.upcoming.isEmpty {
            Section(String(localized: "live.home.upcoming")) {
                ForEach(landing.upcoming) { row($0, viewer: landing.viewer) }
            }
        }
        if !landing.catchUp.isEmpty {
            Section(String(localized: "live.home.catchUp")) {
                ForEach(landing.catchUp) { row($0, viewer: landing.viewer) }
            }
        }
    }

    private func row(_ session: LandingSession, viewer: LandingViewer) -> some View {
        NavigationLink {
            LiveSessionContent(sessionId: session.id)
        } label: {
            LiveSessionRow(session: session, viewer: viewer)
        }
    }
}

/// One class in a list: title, subject · section, teacher, time, and the red LIVE badge.
struct LiveSessionRow: View {
    let session: LandingSession
    let viewer: LandingViewer

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text(session.title)
                    .font(.headline)
                    .lineLimit(2)
                if session.isLive || session.phase == .started || session.phase == .ending {
                    LiveBadge()
                }
                Spacer(minLength: 0)
            }
            let subject = session.subjectLine(showsSection: viewer.showsSection)
            if !subject.isEmpty {
                Text(subject).font(.subheadline).foregroundStyle(.secondary)
            }
            HStack(spacing: 6) {
                if viewer.showsTeacher && !session.teacherName.isEmpty {
                    Label(session.teacherName, systemImage: "person")
                }
                if !session.scheduledStart.isEmpty {
                    Label(session.scheduledStart, systemImage: "clock")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .labelStyle(.titleAndIcon)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

struct LiveBadge: View {
    var body: some View {
        Text(String(localized: "live.room.live"))
            .font(.caption2.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Color(red: 1, green: 0.231, blue: 0.188), in: Capsule())
    }
}

#Preview("Live row") {
    List {
        LiveSessionRow(
            session: LandingSession(id: "s1", title: "Algebra revision", teacherName: "Sample Teacher",
                                    subjectName: "Mathematics", sectionName: "7B",
                                    scheduledStart: "10:00", isLive: true, phase: .started),
            viewer: LandingViewer()
        )
    }
}

#Preview("RTL – Arabic") {
    List {
        LiveSessionRow(
            session: LandingSession(id: "s1", title: "مراجعة الجبر", teacherName: "معلم تجريبي",
                                    subjectName: "الرياضيات", sectionName: "7ب",
                                    scheduledStart: "10:00 ص", isLive: true, phase: .started),
            viewer: LandingViewer()
        )
    }
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
