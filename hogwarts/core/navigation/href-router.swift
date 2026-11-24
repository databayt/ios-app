import Foundation

/// Web path → native route, the same translation Android's `href-router.kt` makes.
///
/// The web is the source of truth for what a page is called; the app answers
/// for the pages it has rebuilt natively and hands every other page to the
/// browser through `WebHandoff`.
enum HrefRouter {

    /// Native route for a locale-less web path, or nil to hand off to the web.
    static func route(for href: String, role: UserRole) -> AppRoute? {
        // «المساعد»: the school's support assistant lives on the web dashboard (`?chat=1` opens it).
        if href.contains("chat=1") { return nil }

        var path = href
        if let cut = path.firstIndex(where: { $0 == "?" || $0 == "#" }) {
            path = String(path[..<cut])
        }
        while path.count > 1 && path.hasSuffix("/") { path.removeLast() }
        if path.isEmpty { path = "/dashboard" }

        switch path {
        case "/dashboard": return .dashboard
        case "/notifications", "/notifications/unread": return .notifications
        case "/notifications/preferences": return .notifications
        case "/messages": return .messages
        case "/events": return .events
        case "/school/analysis", "/readiness":
            return readinessRoles.contains(role) ? .admin : nil
        case "/parents": return role == .guardian ? .guardianChildren : nil
        default: break
        }

        if let nested = nestedRoute(path: path, role: role) { return nested }

        // Only a menu page itself opens natively. A deeper page
        // (/exams/result, /announcements/templates) is a different screen and
        // hands off to the web unless `nestedRoute` names its native mirror.
        guard let item = PlatformNav.all.first(where: { path == $0.href }) else { return nil }
        return nativeRoute(forKey: item.key, role: role)
    }

    /// The native screen behind a platform menu item, or nil when the page is web-only.
    static func nativeRoute(forKey key: String, role: UserRole) -> AppRoute? {
        switch key {
        case "dashboard": return .dashboard
        case "school": return .admin
        case "announcements": return .announcements
        case "finance": return .fees
        case "grades": return .grades
        case "subjects": return .subjects
        case "parents": return role == .guardian ? .guardianChildren : .adminStaff
        case "admission": return .admission
        case "students": return .students
        case "teachers": return .adminStaff
        case "classrooms": return .adminClasses
        case "exams": return .exams
        case "events": return .events
        case "attendance": return .attendance
        case "timetable": return .timetable
        case "library": return .library
        case "assignments": return .lessons
        case "parentPortal": return .guardianChildren
        case "lumos": return .lumosHome
        case "liveClasses": return .live
        case "profile": return .profile
        case "settings": return .settings
        // Web-only pages: transportation, compliance, sales, charts, stats, billing.
        default: return nil
        }
    }

    /// Web sub-pages with a native mirror, matched segment by segment.
    private static func nestedRoute(path: String, role: UserRole) -> AppRoute? {
        let segments = path.split(separator: "/", omittingEmptySubsequences: true).map(String.init)
        guard !segments.isEmpty else { return nil }

        // The textbook reader is the one three-segment page with a native mirror.
        if segments.count == 3, segments[0] == "subjects", segments[2] == "textbook" {
            return .subject(id: segments[1])
        }

        // A timetable or dashboard tap is a SLOT link (`/live/join/<timetableId>`):
        // the room behind it is today's, decided by the server.
        if segments.count == 3, segments[0] == "live", segments[1] == "join" {
            return .liveSession(id: segments[2])
        }
        if segments.count == 3, segments[0] == "live", !liveWebPages.contains(segments[1]) {
            switch segments[2] {
            case "room", "recordings": return .liveSession(id: segments[1])
            default: break
            }
        }

        if segments.count >= 3, segments[0] == "lumos", segments[1] == "courses" {
            let slug = segments[2]
            switch segments.count > 3 ? segments[3] : nil {
            case .none: return .lumosCourse(slug: slug)
            case .some("certificate"): return .lumosCertificate(slug: slug)
            case .some(let lessonId):
                return segments.count == 4 ? .lumosLesson(courseSlug: slug, lessonId: lessonId) : nil
            }
        }

        if segments.count == 3, segments[0] == "library", segments[1] == "books" {
            return .book(id: segments[2])
        }

        guard segments.count == 2 else { return nil }
        let (section, page) = (segments[0], segments[1])
        switch section {
        case "announcements":
            return announcementWebPages.contains(page) ? nil : .announcement(id: page)
        case "library":
            switch page {
            case "books": return .library
            // The web calls the reader's own borrow records "my profile".
            case "my-profile": return .libraryBorrowings
            default: return nil
            }
        case "lumos":
            return page == "courses" ? .lumosCourses : nil
        case "subjects":
            return subjectWebPages.contains(page) ? nil : .subject(id: page)
        case "live":
            return liveWebPages.contains(page) ? nil : .liveSession(id: page)
        case "exams":
            switch page {
            case "upcoming": return .exams
            case "qbank": return questionBankRoles.contains(role) ? .exams : nil
            default: return examWebPages.contains(page) ? nil : .exam(id: page)
            }
        default:
            return nil
        }
    }

    /// /live tools without a native mirror (staff surfaces); any other segment is a class id.
    private static let liveWebPages: Set<String> = ["dashboard", "schedule", "settings", "network-test"]

    /// /subjects sub-pages that are pages in their own right, not a subject.
    private static let subjectWebPages: Set<String> = [
        "catalog", "contribute", "contributions", "elementary", "middle", "high",
    ]

    /// Writer pages under /announcements that stay on the web.
    private static let announcementWebPages: Set<String> = [
        "add", "templates", "archived", "settings", "config",
    ]

    /// /exams sub-pages without a native mirror; any other segment is an exam id.
    private static let examWebPages: Set<String> = [
        "new", "manage", "generate", "mark", "result", "quiz", "mock", "templates",
        "certificates", "paper", "progress", "quick", "report-cards",
    ]

    /// Roles that can open class readiness.
    private static let readinessRoles: Set<UserRole> = [.admin, .developer, .teacher]

    /// Roles that can open the question bank.
    private static let questionBankRoles: Set<UserRole> = [.teacher, .admin, .developer]
}

/// Opens a school page on the web for the destinations the app has no native
/// screen for (school configuration, sales, compliance, billing…), keeping the
/// menu an exact mirror of the web's.
///
/// Pages are school-scoped by subdomain: `https://{domain}.balqalam.com/{lang}{href}`.
enum WebHandoff {
    static let rootDomain = "balqalam.com"

    static func url(schoolDomain: String?, lang: String, href: String) -> URL? {
        let trimmed = schoolDomain?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let host = trimmed.isEmpty ? rootDomain : "\(trimmed).\(rootDomain)"
        let path = href.hasPrefix("/") ? href : "/\(href)"
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/\(lang)\(path)"
        components.queryItems = [URLQueryItem(name: "app", value: "1")]
        return components.url
    }
}
