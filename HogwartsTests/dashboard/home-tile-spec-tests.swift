import Foundation
import Testing
@testable import Hogwarts

@Suite("buildHomeTiles role visibility")
@MainActor
struct HomeTilesRoleTests {

    @Test("Admin role gets the Students + Admin Console tiles")
    func adminTiles() {
        let labels = labelsForRole(.admin)
        #expect(labels.contains("dashboard.action.students"))
        #expect(labels.contains("home.action.adminConsole"))
        // Teacher- and guardian-only tiles must not show.
        #expect(!labels.contains("home.action.teacherWorkspace"))
        #expect(!labels.contains("home.action.children"))
    }

    @Test("Teacher role gets the Teacher Workspace tile but not Students")
    func teacherTiles() {
        let labels = labelsForRole(.teacher)
        #expect(labels.contains("home.action.teacherWorkspace"))
        #expect(!labels.contains("dashboard.action.students"))
        #expect(!labels.contains("home.action.adminConsole"))
        #expect(!labels.contains("home.action.children"))
    }

    @Test("Guardian role gets the Children tile")
    func guardianTiles() {
        let labels = labelsForRole(.guardian)
        #expect(labels.contains("home.action.children"))
        #expect(!labels.contains("home.action.teacherWorkspace"))
        #expect(!labels.contains("home.action.adminConsole"))
    }

    @Test("Student role only sees the always-on tiles")
    func studentTiles() {
        let labels = labelsForRole(.student)
        // Always on
        #expect(labels.contains("dashboard.action.attendance"))
        #expect(labels.contains("home.action.notifications"))
        // Role-only
        #expect(!labels.contains("dashboard.action.students"))
        #expect(!labels.contains("home.action.adminConsole"))
        #expect(!labels.contains("home.action.teacherWorkspace"))
        #expect(!labels.contains("home.action.children"))
    }

    @Test("Developer role inherits admin tiles")
    func developerTiles() {
        let labels = labelsForRole(.developer)
        // .developer.isAdmin is true → admin tiles show.
        #expect(labels.contains("home.action.adminConsole"))
    }

    private func labelsForRole(_ role: UserRole) -> [String] {
        let tiles = buildHomeTiles(role: role, counts: .zero, go: { _ in })
        return tiles.map { String(describing: $0.label) }
    }
}

@Suite("HomeSheet.id")
struct HomeSheetIdTests {

    @Test("id matches rawValue", arguments: HomeSheet.allCasesForTesting)
    func idMatchesRaw(_ sheet: HomeSheet) {
        #expect(sheet.id == sheet.rawValue)
    }
}

private extension HomeSheet {
    /// Manual inventory — the enum doesn't conform to CaseIterable so we
    /// list cases explicitly. Keeping this list in tests catches the gap
    /// when a new sheet is added without test wiring.
    static let allCasesForTesting: [HomeSheet] = [
        .announcements, .events, .subjects, .library, .stream, .admission,
        .fees, .exams, .assignments, .reportCards, .idCard,
        .guardianChildren, .teacherWorkspace, .adminConsole,
    ]
}
