import SwiftUI

// MARK: - HelpView
//
// Self-service support hub: searchable FAQ + escalation path to support.
// Mirrors web's `/help` route surfaced in the platform sidebar.
//
// FAQ entries live in the String Catalog (`help.faq.*`) so translators can
// expand them without code changes; the view picks up new entries from
// `HelpFAQEntry.all` automatically.

struct HelpView: View {
    @State private var query: String = ""
    @State private var expandedID: HelpFAQEntry.ID?

    private var filtered: [HelpFAQEntry] {
        guard !query.isEmpty else { return HelpFAQEntry.all }
        let needle = query.lowercased()
        return HelpFAQEntry.all.filter {
            $0.question.lowercased().contains(needle)
            || $0.answer.lowercased().contains(needle)
        }
    }

    var body: some View {
        List {
            Section {
                ForEach(filtered) { entry in
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedID == entry.id },
                            set: { isOpen in expandedID = isOpen ? entry.id : nil }
                        )
                    ) {
                        Text(entry.answer)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    } label: {
                        Label(entry.question, systemImage: entry.systemImage)
                            .font(.body.weight(.medium))
                    }
                    .accessibilityHint(Text("help.faq.toggleHint"))
                }
            } header: {
                Text("help.faq.section")
            }

            Section {
                Link(destination: URL(string: "mailto:support@databayt.org")!) {
                    Label(String(localized: "help.contactSupport"), systemImage: "envelope")
                }
                Link(destination: URL(string: "https://databayt.org/docs")!) {
                    Label(String(localized: "help.openDocumentation"), systemImage: "book")
                }
                Link(destination: URL(string: "https://github.com/databayt/hogwarts/issues/new?labels=report")!) {
                    Label(String(localized: "help.reportIssue"), systemImage: "exclamationmark.bubble")
                }
            } header: {
                Text("help.contact.section")
            } footer: {
                Text("help.contact.footer")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(Text("profile.help"))
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, prompt: Text("help.search.prompt"))
    }
}

// MARK: - FAQ catalog

struct HelpFAQEntry: Identifiable, Hashable {
    let id: String
    let question: String
    let answer: String
    let systemImage: String

    static let all: [HelpFAQEntry] = [
        .init(
            id: "login",
            question: String(localized: "help.faq.login.q"),
            answer: String(localized: "help.faq.login.a"),
            systemImage: "key"
        ),
        .init(
            id: "biometric",
            question: String(localized: "help.faq.biometric.q"),
            answer: String(localized: "help.faq.biometric.a"),
            systemImage: "faceid"
        ),
        .init(
            id: "language",
            question: String(localized: "help.faq.language.q"),
            answer: String(localized: "help.faq.language.a"),
            systemImage: "globe"
        ),
        .init(
            id: "notifications",
            question: String(localized: "help.faq.notifications.q"),
            answer: String(localized: "help.faq.notifications.a"),
            systemImage: "bell"
        ),
        .init(
            id: "offline",
            question: String(localized: "help.faq.offline.q"),
            answer: String(localized: "help.faq.offline.a"),
            systemImage: "wifi.slash"
        ),
        .init(
            id: "school",
            question: String(localized: "help.faq.switchSchool.q"),
            answer: String(localized: "help.faq.switchSchool.a"),
            systemImage: "building.2"
        )
    ]
}

#Preview("LTR") {
    NavigationStack { HelpView() }
}

#Preview("RTL") {
    NavigationStack { HelpView() }
        .environment(\.layoutDirection, .rightToLeft)
}
