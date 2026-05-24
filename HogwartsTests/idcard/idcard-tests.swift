import Foundation
import Testing
@testable import Hogwarts

@Suite("IDCardUser.subtitle")
struct IDCardUserSubtitleTests {

    @Test("Position wins over department")
    func positionFirst() {
        let u = make(role: "STAFF", position: "Principal", department: "Admin")
        #expect(u.subtitle == "Principal")
    }

    @Test("Department when no position")
    func department() {
        let u = make(role: "TEACHER", position: nil, department: "Mathematics")
        #expect(u.subtitle == "Mathematics")
    }

    @Test("Grade · Section for students")
    func gradeAndSection() {
        let u = make(role: "STUDENT", grade: "Grade 5", section: "A")
        #expect(u.subtitle == "Grade 5 · A")
    }

    @Test("Grade alone when section missing")
    func gradeOnly() {
        let u = make(role: "STUDENT", grade: "Grade 5", section: nil)
        #expect(u.subtitle == "Grade 5")
    }

    @Test("Falls back to role displayName when nothing else")
    func roleFallback() {
        let u = make(role: "GUARDIAN")
        // displayName is localized; just assert non-empty fallback ran.
        #expect(!u.subtitle.isEmpty)
    }

    @Test("fullName joins given + family")
    func fullName() {
        let u = make(role: "STUDENT", given: "Sara", family: "Hassan")
        #expect(u.fullName == "Sara Hassan")
    }

    private func make(
        role: String,
        given: String = "First",
        family: String = "Last",
        position: String? = nil,
        department: String? = nil,
        grade: String? = nil,
        section: String? = nil
    ) -> IDCardUser {
        IDCardUser(
            id: "u1", givenName: given, familyName: family,
            email: nil, role: role, photoUrl: nil,
            idNumber: nil, bloodGroup: nil,
            section: section, grade: grade,
            department: department, position: position
        )
    }
}

@Suite("IDCardSchool.displayName(for:)")
struct IDCardSchoolDisplayNameTests {

    @Test("English locale prefers nameEn")
    func english() {
        let s = IDCardSchool(
            id: "1", name: "مدرسة", nameEn: "School EN",
            logoUrl: nil, address: nil, phone: nil, email: nil, website: nil
        )
        #expect(s.displayName(for: Locale(identifier: "en")) == "School EN")
    }

    @Test("Arabic locale uses canonical")
    func arabic() {
        let s = IDCardSchool(
            id: "1", name: "مدرسة", nameEn: "School EN",
            logoUrl: nil, address: nil, phone: nil, email: nil, website: nil
        )
        #expect(s.displayName(for: Locale(identifier: "ar")) == "مدرسة")
    }
}
