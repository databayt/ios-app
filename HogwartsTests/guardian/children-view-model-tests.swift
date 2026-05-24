import Foundation
import Testing
@testable import Hogwarts

@Suite("ChildListItem display helpers")
struct ChildListItemDisplayTests {

    @Test("fullName joins given + family with single space")
    func fullName() {
        let c = ChildListItem(
            id: "1", givenName: "Layla", familyName: "Al-Hashimi",
            gender: nil, dateOfBirth: nil, photoUrl: nil, status: nil,
            relationship: nil, section: nil, grade: nil
        )
        #expect(c.fullName == "Layla Al-Hashimi")
    }

    @Test("fullName drops empty parts cleanly")
    func fullNameEmptyPart() {
        let onlyGiven = ChildListItem(
            id: "1", givenName: "Adam", familyName: "",
            gender: nil, dateOfBirth: nil, photoUrl: nil, status: nil,
            relationship: nil, section: nil, grade: nil
        )
        #expect(onlyGiven.fullName == "Adam")
    }

    @Test("classLine combines grade and section with separator")
    func classLineBoth() {
        let c = ChildListItem(
            id: "1", givenName: "X", familyName: "Y",
            gender: nil, dateOfBirth: nil, photoUrl: nil, status: nil,
            relationship: nil, section: "A", grade: "Grade 5"
        )
        #expect(c.classLine == "Grade 5 · A")
    }

    @Test("classLine falls back to whichever side is present")
    func classLineFallback() {
        let onlyGrade = ChildListItem(
            id: "1", givenName: "X", familyName: "Y",
            gender: nil, dateOfBirth: nil, photoUrl: nil, status: nil,
            relationship: nil, section: nil, grade: "Grade 3"
        )
        #expect(onlyGrade.classLine == "Grade 3")

        let onlySection = ChildListItem(
            id: "1", givenName: "X", familyName: "Y",
            gender: nil, dateOfBirth: nil, photoUrl: nil, status: nil,
            relationship: nil, section: "B", grade: nil
        )
        #expect(onlySection.classLine == "B")
    }

    @Test("classLine returns nil when both empty/missing")
    func classLineNil() {
        let c = ChildListItem(
            id: "1", givenName: "X", familyName: "Y",
            gender: nil, dateOfBirth: nil, photoUrl: nil, status: nil,
            relationship: nil, section: nil, grade: nil
        )
        #expect(c.classLine == nil)
    }
}
