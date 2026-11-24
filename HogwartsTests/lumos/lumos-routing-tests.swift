import Foundation
import Testing
@testable import Hogwarts

/// The web is the source of truth for what a page is called. These tests pin
/// the translation the app makes: a page with a native mirror opens natively,
/// every other page is the browser's.
@Suite("Href router")
struct HrefRouterTests {

    @Test("menu pages open their native screen")
    func menuPages() {
        #expect(HrefRouter.route(for: "/dashboard", role: .student) == .dashboard)
        #expect(HrefRouter.route(for: "/lumos", role: .student) == .lumosHome)
        #expect(HrefRouter.route(for: "/live", role: .teacher) == .live)
        #expect(HrefRouter.route(for: "/library", role: .student) == .library)
        #expect(HrefRouter.route(for: "/attendance", role: .guardian) == .attendance)
        #expect(HrefRouter.route(for: "/profile", role: .student) == .profile)
    }

    @Test("query strings and trailing slashes do not change the route")
    func normalisation() {
        #expect(HrefRouter.route(for: "/library/", role: .student) == .library)
        #expect(HrefRouter.route(for: "/events?page=2", role: .teacher) == .events)
        #expect(HrefRouter.route(for: "/timetable#today", role: .student) == .timetable)
    }

    @Test("Lumos pages translate page by page")
    func lumosPages() {
        #expect(HrefRouter.route(for: "/lumos/courses", role: .student) == .lumosCourses)
        #expect(
            HrefRouter.route(for: "/lumos/courses/algebra", role: .student)
                == .lumosCourse(slug: "algebra")
        )
        #expect(
            HrefRouter.route(for: "/lumos/courses/algebra/certificate", role: .student)
                == .lumosCertificate(slug: "algebra")
        )
        #expect(
            HrefRouter.route(for: "/lumos/courses/algebra/lesson-9", role: .student)
                == .lumosLesson(courseSlug: "algebra", lessonId: "lesson-9")
        )
        // A deeper page under a lesson has no native mirror.
        #expect(HrefRouter.route(for: "/lumos/courses/algebra/lesson-9/notes", role: .student) == nil)
    }

    @Test("library, subjects and live sub-pages translate")
    func nestedPages() {
        #expect(HrefRouter.route(for: "/library/books/b1", role: .student) == .book(id: "b1"))
        #expect(HrefRouter.route(for: "/library/my-profile", role: .student) == .libraryBorrowings)
        #expect(HrefRouter.route(for: "/subjects/maths/textbook", role: .student) == .subject(id: "maths"))
        #expect(HrefRouter.route(for: "/subjects/catalog", role: .student) == nil)
        #expect(HrefRouter.route(for: "/live/join/t1", role: .student) == .liveSession(id: "t1"))
        #expect(HrefRouter.route(for: "/live/network-test", role: .teacher) == nil)
        #expect(HrefRouter.route(for: "/exams/upcoming", role: .student) == .exams)
        #expect(HrefRouter.route(for: "/exams/exam-1", role: .student) == .exam(id: "exam-1"))
        #expect(HrefRouter.route(for: "/exams/result", role: .student) == nil)
        #expect(HrefRouter.route(for: "/announcements/templates", role: .admin) == nil)
        #expect(HrefRouter.route(for: "/announcements/a1", role: .student) == .announcement(id: "a1"))
    }

    @Test("web-only pages stay on the web")
    func webOnly() {
        #expect(HrefRouter.route(for: "/sales", role: .admin) == nil)
        #expect(HrefRouter.route(for: "/compliance", role: .admin) == nil)
        #expect(HrefRouter.route(for: "/transportation", role: .admin) == nil)
        #expect(HrefRouter.route(for: "/billing", role: .developer) == nil)
        #expect(HrefRouter.route(for: "/dashboard?chat=1", role: .student) == nil)
    }

    @Test("role gates hold: a student never opens staff pages")
    func roleGates() {
        #expect(HrefRouter.route(for: "/parents", role: .student) == nil)
        #expect(HrefRouter.route(for: "/parents", role: .guardian) == .guardianChildren)
        #expect(HrefRouter.route(for: "/readiness", role: .student) == nil)
        #expect(HrefRouter.route(for: "/readiness", role: .teacher) == .admin)
        #expect(HrefRouter.route(for: "/exams/qbank", role: .student) == nil)
        #expect(HrefRouter.route(for: "/exams/qbank", role: .teacher) == .exams)
    }
}

@Suite("Platform menu")
struct PlatformNavTests {

    @Test("a student sees the learning rows and no school administration")
    func studentRows() {
        let keys = PlatformNav.visible(role: .student).map(\.key)
        #expect(keys.contains("lumos"))
        #expect(keys.contains("liveClasses"))
        #expect(keys.contains("library"))
        #expect(!keys.contains("school"))
        #expect(!keys.contains("sales"))
        #expect(!keys.contains("billing"))
        // The web's order is the menu's order.
        #expect(keys.first == "dashboard")
    }

    @Test("an admin sees the school rows")
    func adminRows() {
        let keys = PlatformNav.visible(role: .admin).map(\.key)
        #expect(keys.contains("school"))
        #expect(keys.contains("sales"))
        #expect(keys.contains("teachers"))
        #expect(!keys.contains("billing"))
    }

    @Test("a developer sees every row, including billing")
    func developerRows() {
        let keys = Set(PlatformNav.visible(role: .developer).map(\.key))
        #expect(keys.contains("billing"))
        #expect(keys.contains("charts"))
        #expect(keys.contains("stats"))
        // The web's sidebar gates rows by role, not by seniority: a developer
        // does not get a student's grades row.
        #expect(!keys.contains("grades"))
        #expect(keys.contains("school") && keys.contains("sales"))
    }

    @Test("a school's enabled modules hide the rows it turned off")
    func moduleToggles() {
        let keys = PlatformNav.visible(role: .admin, enabledModules: ["library", "lumos"]).map(\.key)
        #expect(keys.contains("library"))
        #expect(keys.contains("lumos"))
        // `alwaysVisible` rows survive a module list that omits them.
        #expect(keys.contains("dashboard"))
        #expect(keys.contains("profile"))
        #expect(!keys.contains("students"))
    }

    @Test("no role sees nothing")
    func everyRoleHasARow() {
        for role in UserRole.allCases {
            #expect(!PlatformNav.visible(role: role).isEmpty, "\(role.rawValue) has no menu row")
        }
    }

    @Test("every menu row with a native mirror names a real screen")
    func nativeMirrors() {
        for item in PlatformNav.all {
            for role in item.roles {
                let route = HrefRouter.nativeRoute(forKey: item.key, role: role)
                if let route, route == .dashboard {
                    #expect(item.key == "dashboard")
                }
            }
        }
        #expect(HrefRouter.nativeRoute(forKey: "lumos", role: .student) == .lumosHome)
        #expect(HrefRouter.nativeRoute(forKey: "billing", role: .developer) == nil)
    }
}

@Suite("App router")
@MainActor
struct AppRouterTests {

    @Test("pushing a route appends; the dashboard pops to the root")
    func pushAndPop() {
        let router = AppRouter()
        router.push(.lumosHome)
        router.push(.lumosCourse(slug: "algebra"))
        #expect(router.path == [.lumosHome, .lumosCourse(slug: "algebra")])
        router.push(.dashboard)
        #expect(router.path.isEmpty)
    }

    @Test("an href with a native mirror pushes, one without does not")
    func openHref() {
        let router = AppRouter()
        #expect(router.open(href: "/lumos/courses/algebra", role: .student))
        #expect(router.path == [.lumosCourse(slug: "algebra")])
        #expect(!router.open(href: "/billing", role: .developer))
        #expect(router.path.count == 1)
    }
}

@Suite("Web handoff")
struct WebHandoffTests {

    @Test("a school page is school-scoped, locale-prefixed and marked as the app's")
    func schoolURL() throws {
        let url = try #require(WebHandoff.url(schoolDomain: "greenwood", lang: "ar", href: "/billing"))
        #expect(url.host == "greenwood.balqalam.com")
        #expect(url.path == "/ar/billing")
        #expect(url.query?.contains("app=1") == true)
    }

    @Test("a school with no subdomain falls back to the apex host")
    func apexURL() throws {
        let url = try #require(WebHandoff.url(schoolDomain: nil, lang: "en", href: "sales"))
        #expect(url.host == "balqalam.com")
        #expect(url.path == "/en/sales")
    }
}

@Suite("Home tiles")
struct HomeTilesTests {

    @Test("every role has a drawer, and a student gets the quiz game")
    func tiles() {
        for role in UserRole.allCases {
            #expect(!HomeTiles.items(for: role).isEmpty, "\(role.rawValue) has no tile")
        }
        #expect(HomeTiles.items(for: .student).contains { $0.route == .quizGame })
        #expect(HomeTiles.items(for: .guardian).contains { $0.route == .guardianChildren })
        #expect(HomeTiles.items(for: .admin).contains { $0.route == .admission })
    }

    @Test("the learning tiles are the first four for everyone")
    func learningFirst() {
        let routes = HomeTiles.items(for: .student).prefix(4).map(\.route)
        #expect(routes == [.lumosHome, .live, .subjects, .library])
    }
}
