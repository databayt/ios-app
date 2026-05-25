import SwiftUI
import SwiftData
import CoreSpotlight

/// Main app entry point
/// Mirrors: src/app/layout.tsx
@main
struct HogwartsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var authManager = AuthManager()
    @State private var tenantContext = TenantContext()
    @State private var biometricService = BiometricService()
    @AppStorage("appTheme") private var appTheme: String = AppTheme.system.rawValue
    @AppStorage("selectedLanguage") private var selectedLanguage: String = ""

    init() {
        // Crash + telemetry sink. No-op when SENTRY_DSN is empty (debug default).
        // OBS-001 / CORE-008.
        SentryBootstrap.start()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authManager)
                .environment(tenantContext)
                .environment(biometricService)
                .modelContainer(DataContainer.shared.container)
                .preferredColorScheme(resolvedColorScheme)
                .environment(\.locale, resolvedLocale)
                .environment(\.layoutDirection, resolvedLayoutDirection)
        }
    }

    /// Resolve in-app language override to a Locale; empty string means
    /// "follow the system" so the system locale is used.
    private var resolvedLocale: Locale {
        guard !selectedLanguage.isEmpty else { return .current }
        return Locale(identifier: selectedLanguage)
    }

    /// Layout direction is derived from the resolved locale so RTL flips
    /// happen instantly when the user switches language in-app, without
    /// requiring an app relaunch.
    private var resolvedLayoutDirection: LayoutDirection {
        let code = resolvedLocale.language.languageCode?.identifier
            ?? resolvedLocale.identifier
        return ["ar", "he", "fa", "ur"].contains(code) ? .rightToLeft : .leftToRight
    }

    /// Resolve @AppStorage theme to ColorScheme
    private var resolvedColorScheme: ColorScheme? {
        switch AppTheme(rawValue: appTheme) {
        case .light: return .light
        case .dark: return .dark
        case .system, .none: return nil
        }
    }
}

/// Root content view with auth check
/// Mirrors: src/app/[lang]/layout.tsx
struct ContentView: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(TenantContext.self) private var tenantContext
    @Environment(BiometricService.self) private var biometricService

    var body: some View {
        Group {
            if authManager.isAuthenticated {
                if tenantContext.isValid {
                    if biometricService.isBiometricEnabled && !biometricService.isUnlocked {
                        BiometricPromptView()
                    } else {
                        MainTabView()
                    }
                } else {
                    SchoolSelectionView()
                }
            } else {
                LoginView()
            }
        }
        .task {
            await authManager.restoreSession()
            restoreLastSchool()
            // Auto-unlock if biometric is disabled
            if !biometricService.isBiometricEnabled {
                biometricService.isUnlocked = true
            }
        }
        // AUTH-014 — direct URL open (e.g. `hogwarts://` or http from
        // a non-NSUserActivity source).
        .onOpenURL { url in
            handleDeepLink(url: url)
        }
        // AUTH-014 — Universal Links from Mail/Safari arrive as a
        // `NSUserActivityTypeBrowsingWeb` activity whose `webpageURL`
        // is the http(s) URL the user tapped.
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
            guard let url = activity.webpageURL else { return }
            handleDeepLink(url: url)
        }
        // SRCH-001 — Spotlight result taps surface as a
        // `CSSearchableItemActionType` activity whose userInfo carries
        // the item's unique identifier we registered in SpotlightIndexer.
        .onContinueUserActivity(CSSearchableItemActionType) { activity in
            guard let identifier = activity.userInfo?[CSSearchableItemActivityIdentifier] as? String else {
                return
            }
            handleSpotlight(identifier: identifier)
        }
    }

    /// Dispatch a URL → typed destination → navigation state mutation.
    /// Unknown URLs are silently ignored (returning nil from the router).
    private func handleDeepLink(url: URL) {
        guard let destination = DeepLinkRouter.destination(from: url) else { return }
        if let navDestination = destination.asNotificationDestination {
            NotificationNavigationState.shared.navigate(to: navDestination)
        }
        // Auth-flow variants (passwordReset / emailVerification /
        // inviteAccept) are picked up by LoginView's own observer.
    }

    private func handleSpotlight(identifier: String) {
        guard let destination = DeepLinkRouter.destination(fromSpotlightIdentifier: identifier),
              let navDestination = destination.asNotificationDestination else {
            return
        }
        NotificationNavigationState.shared.navigate(to: navDestination)
    }

    /// Restore last selected school from keychain on session restore
    private func restoreLastSchool() {
        if authManager.isAuthenticated,
           let lastSchoolId = KeychainService().get(.lastSchoolId),
           let sessionSchoolId = authManager.session?.schoolId,
           lastSchoolId == sessionSchoolId {
            tenantContext.setTenant(schoolId: lastSchoolId)
        } else if authManager.isAuthenticated,
                  let schoolId = authManager.session?.schoolId {
            tenantContext.setTenant(schoolId: schoolId)
        }
    }
}

/// Main tab navigation — role-based tabs
/// Mirrors: src/app/[lang]/s/[subdomain]/(platform)/layout.tsx
///
/// Tab layout per role:
/// Admin/Dev: Dashboard, Students, Messages, Notifications, Profile
/// Teacher:   Dashboard, Schedule, Messages, Notifications, Profile
/// Student:   Dashboard, Schedule, Messages, Notifications, Profile
/// Guardian:  Dashboard, Schedule, Messages, Notifications, Profile
struct MainTabView: View {
    @Environment(AuthManager.self) private var authManager

    /// Single source of truth for the active tab — owned by the
    /// `NotificationNavigationState` singleton so push deep-links from the
    /// `AppDelegate`, dashboard quick-actions, and home-tile taps all
    /// converge on the same instance.
    @State private var navigationState = NotificationNavigationState.shared

    private var role: UserRole {
        authManager.role
    }

    /// Whether this role sees the Students tab (admin/dev only)
    private var showStudentsTab: Bool {
        role.isAdmin
    }

    var body: some View {
        @Bindable var nav = navigationState
        TabView(selection: $nav.selectedTab) {
            // iOS-style 4×4 home grid + glass dock — parity with Android home-screen.
            // Tile taps flip `navigationState.selectedTab`; non-tab destinations are
            // no-ops until the respective screens are wired in later phases.
            HomeScreen(
                counts: .zero,
                onSelectTab: { navigationState.selectedTab = $0 }
            )
                .tabItem {
                    Label(
                        String(localized: "tab.dashboard"),
                        systemImage: "house"
                    )
                }
                .tag(AppTab.dashboard)

            if showStudentsTab {
                StudentsContent()
                    .tabItem {
                        Label(
                            String(localized: "tab.students"),
                            systemImage: "person.2"
                        )
                    }
                    .tag(AppTab.students)
            } else {
                TimetableContent()
                    .tabItem {
                        Label(
                            String(localized: "tab.schedule"),
                            systemImage: "calendar"
                        )
                    }
                    .tag(AppTab.schedule)
            }

            WaMessagesTabRoot()
                .tabItem {
                    Label(
                        String(localized: "tab.messages"),
                        systemImage: "bubble.left.and.bubble.right"
                    )
                }
                .tag(AppTab.messages)

            NotificationsContent()
                .tabItem {
                    Label(
                        String(localized: "tab.notifications"),
                        systemImage: "bell"
                    )
                }
                .tag(AppTab.notifications)

            ProfileContent()
                .tabItem {
                    Label(
                        String(localized: "tab.profile"),
                        systemImage: "person.circle"
                    )
                }
                .tag(AppTab.profile)
        }
        .environment(navigationState)
        .overlay(alignment: .top) {
            SyncStatusBanner()
        }
        // Push deep-links are routed by `AppDelegate` directly into
        // `NotificationNavigationState.shared`; the bound TabView observes
        // the mutation and no `NotificationCenter` bridge is needed here.
    }
}
