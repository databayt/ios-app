import Foundation
import Testing
@testable import Hogwarts

@Suite("AdminSchool.displayName(for:)")
struct AdminSchoolDisplayNameTests {

    @Test("English locale prefers nameEn when present")
    func english() {
        let school = AdminSchool(
            id: "1", name: "مدرسة الملك فهد", nameEn: "King Fahad School",
            domain: nil, totalStudents: 0, totalTeachers: 0, totalSections: 0
        )
        #expect(school.displayName(for: Locale(identifier: "en")) == "King Fahad School")
    }

    @Test("Arabic locale always uses canonical name")
    func arabic() {
        let school = AdminSchool(
            id: "1", name: "مدرسة الملك فهد", nameEn: "King Fahad School",
            domain: nil, totalStudents: 0, totalTeachers: 0, totalSections: 0
        )
        #expect(school.displayName(for: Locale(identifier: "ar")) == "مدرسة الملك فهد")
    }

    @Test("English locale falls back to canonical when nameEn missing")
    func englishFallback() {
        let school = AdminSchool(
            id: "1", name: "King Fahad School", nameEn: nil,
            domain: nil, totalStudents: 0, totalTeachers: 0, totalSections: 0
        )
        #expect(school.displayName(for: Locale(identifier: "en")) == "King Fahad School")

        let blank = AdminSchool(
            id: "2", name: "Canon", nameEn: "",
            domain: nil, totalStudents: 0, totalTeachers: 0, totalSections: 0
        )
        #expect(blank.displayName(for: Locale(identifier: "en")) == "Canon")
    }
}

@Suite("AdminStaffRole")
struct AdminStaffRoleTests {

    @Test("Maps backend strings", arguments: [
        ("TEACHER", AdminStaffRole.teacher),
        ("STAFF", .staff),
    ])
    func mapsCanonical(raw: String, expected: AdminStaffRole) {
        #expect(AdminStaffRole(raw: raw) == expected)
    }

    @Test("Lowercase still maps correctly")
    func lowercase() {
        #expect(AdminStaffRole(raw: "teacher") == .teacher)
        #expect(AdminStaffRole(raw: "staff") == .staff)
    }

    @Test("Unknown for nil and junk")
    func unknown() {
        #expect(AdminStaffRole(raw: nil) == .unknown)
        #expect(AdminStaffRole(raw: "PRINCIPAL") == .unknown)
    }
}

@Suite("AdminStaffMember.fullName")
struct AdminStaffMemberFullNameTests {

    @Test("Joins given + family")
    func joinsBoth() {
        let m = AdminStaffMember(
            id: "1", givenName: "Hala", familyName: "Mansoor",
            email: nil, role: nil, status: nil, photoUrl: nil,
            employeeId: nil, department: nil, position: nil, subject: nil
        )
        #expect(m.fullName == "Hala Mansoor")
    }

    @Test("Drops empty halves")
    func dropsEmpty() {
        let m = AdminStaffMember(
            id: "1", givenName: "Hala", familyName: "",
            email: nil, role: nil, status: nil, photoUrl: nil,
            employeeId: nil, department: nil, position: nil, subject: nil
        )
        #expect(m.fullName == "Hala")
    }
}

@Suite("AdminStaffFilter")
struct AdminStaffFilterTests {

    @Test("apiParam matches backend role values")
    func apiParam() {
        #expect(AdminStaffFilter.all.apiParam == nil)
        #expect(AdminStaffFilter.teachers.apiParam == "teacher")
        #expect(AdminStaffFilter.staff.apiParam == "staff")
    }
}
