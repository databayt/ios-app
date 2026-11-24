import Foundation

/// One entry of the platform menu.
///
/// Literal port of hogwarts `src/components/template/platform-sidebar/config.ts`
/// (through Android `app/src/main/java/org/hogwarts/android/shell/platform-nav.kt`):
/// order, keys, hrefs, roles and `alwaysVisible` must stay identical, so the
/// phone menu is the web's menu. `HogwartsTests/lumos/lumos-routing-tests.swift` pins the list.
struct PlatformNavItem: Identifiable, Hashable, Sendable {
    let key: String
    /// Localizable key for the menu label.
    let titleKey: String
    let href: String
    let roles: Set<UserRole>
    var alwaysVisible: Bool = false

    var id: String { key }
}

enum PlatformNav {
    private static let allRoles: Set<UserRole> = [
        .developer, .admin, .teacher, .student, .guardian, .accountant, .staff, .user,
    ]

    private static func roles(_ roles: UserRole...) -> Set<UserRole> { Set(roles) }

    /// The web's sidebar, in its order.
    static let all: [PlatformNavItem] = [
        PlatformNavItem(key: "dashboard", titleKey: "nav.dashboard", href: "/dashboard", roles: allRoles, alwaysVisible: true),
        PlatformNavItem(key: "school", titleKey: "nav.school", href: "/school", roles: roles(.admin, .developer), alwaysVisible: true),
        PlatformNavItem(key: "sales", titleKey: "nav.sales", href: "/sales", roles: roles(.admin, .developer)),
        PlatformNavItem(key: "announcements", titleKey: "nav.announcements", href: "/announcements", roles: allRoles),
        PlatformNavItem(key: "finance", titleKey: "nav.finance", href: "/finance", roles: allRoles),
        PlatformNavItem(key: "grades", titleKey: "nav.grades", href: "/grades", roles: roles(.admin, .staff, .teacher, .student, .guardian)),
        PlatformNavItem(key: "subjects", titleKey: "nav.subjects", href: "/subjects", roles: roles(.admin, .staff, .teacher, .student)),
        PlatformNavItem(key: "parents", titleKey: "nav.parents", href: "/parents", roles: roles(.admin, .staff)),
        PlatformNavItem(key: "admission", titleKey: "nav.admission", href: "/admission", roles: roles(.admin, .staff, .accountant, .developer)),
        PlatformNavItem(key: "students", titleKey: "nav.students", href: "/students", roles: roles(.admin, .staff, .teacher)),
        PlatformNavItem(key: "teachers", titleKey: "nav.teachers", href: "/teachers", roles: roles(.admin, .staff)),
        PlatformNavItem(key: "classrooms", titleKey: "nav.classrooms", href: "/classrooms", roles: roles(.admin, .staff, .teacher)),
        PlatformNavItem(key: "exams", titleKey: "nav.exams", href: "/exams", roles: roles(.admin, .staff, .teacher, .student, .guardian)),
        PlatformNavItem(key: "events", titleKey: "nav.events", href: "/events", roles: roles(.admin, .staff, .teacher)),
        PlatformNavItem(key: "attendance", titleKey: "nav.attendance", href: "/attendance", roles: roles(.admin, .staff, .teacher, .student, .guardian)),
        PlatformNavItem(key: "timetable", titleKey: "nav.timetable", href: "/timetable", roles: roles(.admin, .teacher, .student)),
        PlatformNavItem(key: "library", titleKey: "nav.library", href: "/library", roles: allRoles),
        PlatformNavItem(key: "transportation", titleKey: "nav.transportation", href: "/transportation", roles: roles(.admin, .staff, .developer)),
        PlatformNavItem(key: "transportationFees", titleKey: "nav.transportFees", href: "/transportation/fees", roles: roles(.accountant, .developer)),
        PlatformNavItem(key: "myTransportation", titleKey: "nav.myTransportation", href: "/transportation/me", roles: roles(.student, .guardian)),
        PlatformNavItem(key: "assignments", titleKey: "nav.assignments", href: "/assignments", roles: roles(.admin, .staff, .teacher, .student, .guardian)),
        PlatformNavItem(key: "parentPortal", titleKey: "nav.parentPortal", href: "/parent", roles: roles(.guardian, .developer)),
        PlatformNavItem(key: "transportationTrips", titleKey: "nav.trips", href: "/transportation/trips", roles: roles(.teacher)),
        PlatformNavItem(key: "lumos", titleKey: "nav.lumos", href: "/lumos", roles: allRoles),
        PlatformNavItem(key: "liveClasses", titleKey: "nav.live", href: "/live", roles: allRoles),
        PlatformNavItem(key: "compliance", titleKey: "nav.compliance", href: "/compliance", roles: roles(.admin, .staff, .developer)),
        PlatformNavItem(key: "profile", titleKey: "nav.profile", href: "/profile", roles: allRoles, alwaysVisible: true),
        PlatformNavItem(key: "settings", titleKey: "nav.settings", href: "/settings", roles: allRoles, alwaysVisible: true),
        PlatformNavItem(key: "charts", titleKey: "nav.charts", href: "/charts", roles: roles(.developer)),
        PlatformNavItem(key: "stats", titleKey: "nav.stats", href: "/stats", roles: roles(.developer)),
        PlatformNavItem(key: "billing", titleKey: "nav.billing", href: "/billing", roles: roles(.developer)),
    ]

    /// The items a role sees, with the school's module toggles applied the way
    /// the web sidebar applies them: `alwaysVisible || enabledModules == nil || key in enabledModules`.
    static func visible(role: UserRole?, enabledModules: [String]? = nil) -> [PlatformNavItem] {
        guard let role else { return [] }
        return all.filter { item in
            item.roles.contains(role) &&
                (item.alwaysVisible || enabledModules == nil || enabledModules!.contains(item.key))
        }
    }
}
