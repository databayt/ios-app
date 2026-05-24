import SwiftUI
import UIKit

// MARK: - HomeScreen
// Source: Figma iOS 26 — Home Screen
// Parity: kotlin-app/feature/dashboard/.../home-screen.kt
//
// Composes wallpaper background + scrollable tile grid + glass dock.
// Tap actions go through `onSelectTab` so the existing TabView selectedTab
// stays in sync — replaced by a Coordinator/Router in a follow-up PR.
//
// Wallpaper resolution order:
//   1. `home-wallpaper` asset (Figma-exported JPG/PNG in Assets.xcassets)
//   2. Gradient fallback (so the screen still looks intentional pre-asset)

struct HomeScreen: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(\.scenePhase) private var scenePhase

    /// Optional injected counts — when nil the view fetches its own via
    /// `HomeViewModel`. Tests / previews keep deterministic counts by passing
    /// a value; production runs use the live fetch.
    var counts: HomeTileBadgeCounts?
    let onSelectTab: (AppTab) -> Void

    @State private var viewModel = HomeViewModel()
    @State private var presentedSheet: HomeSheet?

    private var resolvedCounts: HomeTileBadgeCounts {
        counts ?? viewModel.counts
    }

    var body: some View {
        ZStack {
            wallpaperBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    HomeGrid(
                        tiles: buildHomeTiles(
                            role: authManager.role,
                            counts: resolvedCounts,
                            go: handle(destination:)
                        )
                    )
                }
                HomeDock(items: dockItems)
            }
        }
        .sheet(item: $presentedSheet) { sheet in
            sheetContent(for: sheet)
        }
        .task {
            // Only fetch when no injected counts (tests/previews skip the call).
            if counts == nil { await viewModel.load() }
        }
        .onChange(of: scenePhase) { _, phase in
            // Refresh counts whenever the app returns to foreground so tile
            // badges stay current after backgrounding.
            if phase == .active, counts == nil {
                Task { await viewModel.load() }
            }
        }
        .refreshable {
            if counts == nil { await viewModel.load() }
        }
    }

    private func handle(destination: HomeDestination) {
        switch destination {
        case .tab(let tab):
            onSelectTab(tab)
        case .sheet(let sheet):
            presentedSheet = sheet
        }
    }

    /// Sheet content for each home destination. Wraps every screen in a
    /// `NavigationStack` so it gets its own back-stack independent of the
    /// outer TabView. Unbuilt destinations show a friendly "coming soon"
    /// placeholder so we never present an empty sheet.
    @ViewBuilder
    private func sheetContent(for sheet: HomeSheet) -> some View {
        NavigationStack {
            switch sheet {
            case .announcements:
                AnnouncementsContent()
                    .navigationDestination(for: AnnouncementsRoute.self) { route in
                        if case .detail(let id) = route {
                            AnnouncementDetailView(id: id)
                        }
                    }
            case .events:
                EventsContent()
                    .navigationDestination(for: EventsRoute.self) { route in
                        if case .detail(let id) = route {
                            EventDetailView(id: id)
                        }
                    }
            case .subjects:
                SubjectsContent()
                    .navigationDestination(for: SubjectsRoute.self) { route in
                        if case .detail(let id) = route {
                            SubjectDetailView(id: id)
                        }
                    }
            case .idCard:
                IDCardContent()
            case .reportCards:
                ReportCardsContent()
                    .navigationDestination(for: ReportCardsRoute.self) { route in
                        if case .detail(let id) = route {
                            ReportCardDetailView(id: id)
                        }
                    }
            case .fees:
                FeesContent()
                    .navigationDestination(for: FeesRoute.self) { route in
                        if case .detail(let id) = route {
                            FeeDetailView(id: id)
                        }
                    }
            case .exams:
                ExamsContent()
                    .navigationDestination(for: ExamsRoute.self) { route in
                        switch route {
                        case .detail(let id):
                            ExamDetailView(id: id)
                        case .attempt(let id, let title):
                            ExamAttemptView(examId: id, examTitle: title)
                        case .certificate(let id):
                            ExamCertificateView(examId: id)
                        }
                    }
            case .guardianChildren:
                ChildrenContent()
                    .navigationDestination(for: GuardianRoute.self) { route in
                        if case .child(let id) = route {
                            ChildDetailView(id: id)
                        }
                    }
            case .teacherWorkspace:
                TeacherContent()
            case .adminConsole:
                AdminContent()
                    .navigationDestination(for: AdminRoute.self) { route in
                        switch route {
                        case .staff:   AdminStaffList(viewModel: AdminViewModel())
                        case .classes: AdminClassesList(viewModel: AdminViewModel())
                        }
                    }
            default:
                ComingSoonView(sheet: sheet)
            }
        }
    }

    private var dockItems: [HomeDockItem] {
        [
            HomeDockItem(
                systemImage: "house.fill",
                tint: .accentBlue,
                accessibilityLabel: "tab.dashboard",
                action: { onSelectTab(.dashboard) }
            ),
            HomeDockItem(
                systemImage: "bubble.left.and.bubble.right.fill",
                assetName: "tile-message",
                tint: .accentGreen,
                accessibilityLabel: "tab.messages",
                action: { onSelectTab(.messages) }
            ),
            HomeDockItem(
                systemImage: "bell.fill",
                tint: .accentRed,
                accessibilityLabel: "tab.notifications",
                action: { onSelectTab(.notifications) }
            ),
            HomeDockItem(
                systemImage: "gearshape.fill",
                assetName: "tile-setting",
                tint: .appleGray1,
                accessibilityLabel: "tab.profile",
                action: { onSelectTab(.profile) }
            )
        ]
    }

    @ViewBuilder
    private var wallpaperBackground: some View {
        if UIImage(named: "home-wallpaper") != nil {
            Image("home-wallpaper")
                .resizable()
                .scaledToFill()
        } else {
            // Pleasant fallback so the screen looks deliberate before the
            // Figma JPG ships in Assets.xcassets/home-wallpaper.imageset.
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.10, blue: 0.30),
                    Color(red: 0.20, green: 0.10, blue: 0.45),
                    Color(red: 0.55, green: 0.25, blue: 0.55)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

#Preview("HomeScreen — student LTR") {
    HomeScreen(
        counts: HomeTileBadgeCounts(
            pendingAttendance: 1,
            upcomingExams: 3,
            todayClasses: 5,
            unreadMessages: 12,
            unreadNotifications: 4,
            pendingAssignments: 2
        ),
        onSelectTab: { _ in }
    )
    .environment(AuthManager())
}

#Preview("HomeScreen — admin RTL") {
    HomeScreen(
        counts: HomeTileBadgeCounts(unreadNotifications: 7, pendingAssignments: 3),
        onSelectTab: { _ in }
    )
    .environment(AuthManager())
    .environment(\.layoutDirection, .rightToLeft)
}
