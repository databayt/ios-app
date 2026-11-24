import SwiftUI

/// Every place the app can push, named after the web page it mirrors.
///
/// The Android app navigates with typed Compose routes built from the same
/// web paths; this enum is the Swift equivalent, and `HrefRouter` is the one
/// translator from a web href to a route.
enum AppRoute: Hashable {
    case dashboard

    // Learning
    case lumosHome
    case lumosCourses
    case lumosCourse(slug: String)
    case lumosLesson(courseSlug: String, lessonId: String)
    case lumosCertificate(slug: String)

    case subjects
    case subject(id: String)
    case lessons
    case library
    case libraryBorrowings
    case book(id: String)
    case exams
    case exam(id: String)
    case quizGame

    // School life
    case announcements
    case announcement(id: String)
    case events
    case event(id: String)
    case timetable
    case attendance
    case grades
    case reportCards
    case reportCard(id: String)
    case fees
    case idCard
    case live
    case liveSession(id: String)

    // People and administration
    case students
    case guardianChildren
    case teacher
    case admin
    case adminStaff
    case adminClasses
    case admission

    // Account
    case messages
    case notifications
    case profile
    case settings
    case help
    case about
}

/// The navigation stack the whole app shares.
///
/// One stack wraps the tab bar, so a tile, a menu row, a dashboard card and a
/// push notification all push into the same place and the back button always
/// leads home.
@MainActor
@Observable
final class AppRouter {
    var path: [AppRoute] = []
    var isMenuPresented = false

    func push(_ route: AppRoute) {
        guard route != .dashboard else { return popToRoot() }
        path.append(route)
    }

    func popToRoot() {
        path.removeAll()
    }

    /// A route pushed from a web path, or nil when the page has no native mirror.
    @discardableResult
    func open(href: String, role: UserRole) -> Bool {
        guard let route = HrefRouter.route(for: href, role: role) else { return false }
        push(route)
        return true
    }
}

/// Builds the screen for a route. Every case is a feature the app already has,
/// and each root also registers the destinations its own screen pushes into,
/// so a feature's internal links resolve in the app's one stack.
struct AppRouteView: View {
    let route: AppRoute

    @Environment(TenantContext.self) private var tenantContext
    @Environment(AuthManager.self) private var authManager
    @Environment(AppRouter.self) private var router

    var body: some View {
        switch route {
        case .dashboard:
            DashboardContent()

        // MARK: Learning
        case .lumosHome:
            LumosHomeContent()
        case .lumosCourses:
            LumosCoursesContent()
        case .lumosCourse(let slug):
            LumosCourseContent(slug: slug)
        case .lumosLesson(let courseSlug, let lessonId):
            LumosLessonContent(courseSlug: courseSlug, lessonId: lessonId)
        case .lumosCertificate(let slug):
            LumosCertificateContent(slug: slug)

        case .subjects:
            SubjectsContent()
                .navigationDestination(for: SubjectsRoute.self) { route in
                    if case .detail(let id) = route { SubjectDetailView(id: id) }
                }
        case .subject(let id):
            SubjectDetailView(id: id)
        case .lessons:
            LessonPlansContent(tenantContext: tenantContext)
        case .library:
            BookCatalogView(tenantContext: tenantContext)
        case .libraryBorrowings:
            MyBorrowingsView(tenantContext: tenantContext)
        case .book(let id):
            BookDetailView(bookId: id, tenantContext: tenantContext)
        case .exams:
            ExamsContent()
                .navigationDestination(for: ExamsRoute.self) { route in
                    switch route {
                    case .detail(let id): ExamDetailView(id: id)
                    case .attempt(let id, let title): ExamAttemptView(examId: id, examTitle: title)
                    case .certificate(let id): ExamCertificateView(examId: id)
                    }
                }
        case .exam(let id):
            ExamDetailView(id: id)
        case .quizGame:
            GameHubContent(tenantContext: tenantContext)

        // MARK: School life
        case .announcements:
            AnnouncementsContent()
                .navigationDestination(for: AnnouncementsRoute.self) { route in
                    if case .detail(let id) = route { AnnouncementDetailView(id: id) }
                }
        case .announcement(let id):
            AnnouncementDetailView(id: id)
        case .events:
            EventsContent()
        case .event(let id):
            EventDetailView(id: id)
        case .timetable:
            TimetableContent()
        case .attendance:
            AttendanceContent()
        case .grades:
            GradesContent()
        case .reportCards:
            ReportCardsContent()
                .navigationDestination(for: ReportCardsRoute.self) { route in
                    if case .detail(let id) = route { ReportCardDetailView(id: id) }
                }
        case .reportCard(let id):
            ReportCardDetailView(id: id)
        case .fees:
            FeesContent(studentId: nil)
                .navigationDestination(for: FeesRoute.self) { route in
                    if case .detail(let id) = route { FeeDetailView(id: id) }
                }
        case .idCard:
            IDCardContent()
        case .live:
            LiveHomeContent()
        case .liveSession(let id):
            LiveSessionContent(sessionId: id)

        // MARK: People and administration
        case .students:
            StudentsContent()
        case .guardianChildren:
            ChildrenContent()
                .navigationDestination(for: GuardianRoute.self) { route in
                    switch route {
                    case .child(let id): ChildDetailView(id: id)
                    case .childAttendance: AttendanceContent()
                    case .childGrades: GradesContent()
                    case .childFees(let id): FeesContent(studentId: id)
                    case .childTimetable: TimetableContent()
                    }
                }
        case .teacher:
            TeacherContent()
        case .admin:
            AdminContent()
                .navigationDestination(for: AdminRoute.self) { route in
                    switch route {
                    case .staff: AdminStaffScreen()
                    case .classes: AdminClassesScreen()
                    }
                }
        case .adminStaff:
            AdminStaffScreen()
        case .adminClasses:
            AdminClassesScreen()
        case .admission:
            ApplicationsContent(tenantContext: tenantContext)

        // MARK: Account
        case .messages:
            MessagesContent()
        case .notifications:
            NotificationsContent()
        case .profile:
            ProfileContent()
        case .settings:
            SettingsContent(
                onNavigateToProfile: { router.push(.profile) },
                onLogout: { authManager.signOut() }
            )
        case .help:
            WebPageView(href: "/help")
        case .about:
            AboutView()
        }
    }
}
