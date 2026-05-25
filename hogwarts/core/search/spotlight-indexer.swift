import Foundation
import CoreSpotlight
import UniformTypeIdentifiers

/// SRCH-001 — Tenant-scoped Core Spotlight indexer.
///
/// Each `CSSearchableItem` lives under a domain identifier of
/// `org.databayt.Hogwarts.{schoolId}` so iOS can wipe a tenant cleanly
/// on school switch via `deleteSearchableItems(withDomainIdentifiers:)`.
/// Item identifiers are `{type}:{id}` — the same shape that
/// `DeepLinkRouter.destination(fromSpotlightIdentifier:)` parses,
/// keeping the round-trip symmetric.
///
/// What gets indexed today:
///   - Announcements (title, summary, published date)
///   - Conversations (counterparty name, last-message preview)
///   - Contacts (name, role)
///
/// What is NOT indexed (deliberately):
///   - Grades, fees, attendance — privacy-sensitive; users searching
///     "Ahmed" should not see "F in Math" pop up on Spotlight.
///
/// Permissions enforced at result-render time (not index time) per
/// F-SEARCH cross-cutting: a user with a stale Spotlight entry for a
/// conversation they were removed from will still see the item appear,
/// but tapping it routes through the same gated screens.
enum SpotlightIndexer {

    // MARK: - Domain + Identifier

    /// Per-tenant domain identifier so school switch can drop one
    /// tenant's index without touching others.
    static func domainIdentifier(for schoolId: String) -> String {
        "org.databayt.Hogwarts.\(schoolId)"
    }

    /// Composite identifier matching `DeepLinkRouter` parser.
    static func itemIdentifier(type: String, id: String) -> String {
        "\(type):\(id)"
    }

    // MARK: - Bulk index API

    /// Index a list of announcements for a school. Replaces existing
    /// announcement entries for that domain.
    static func indexAnnouncements<S: Sequence>(_ items: S, schoolId: String) async throws
    where S.Element == (id: String, title: String, summary: String?, publishedAt: Date?) {
        let searchables = items.map { item in
            makeItem(
                identifier: itemIdentifier(type: "announcement", id: item.id),
                domain: domainIdentifier(for: schoolId),
                title: item.title,
                description: item.summary,
                date: item.publishedAt,
                contentType: .text
            )
        }
        try await CSSearchableIndex.default().indexSearchableItems(searchables)
    }

    /// Index a list of conversations.
    static func indexConversations<S: Sequence>(_ items: S, schoolId: String) async throws
    where S.Element == (id: String, counterpartyName: String, lastMessage: String?, lastMessageAt: Date?) {
        let searchables = items.map { item in
            makeItem(
                identifier: itemIdentifier(type: "message", id: item.id),
                domain: domainIdentifier(for: schoolId),
                title: item.counterpartyName,
                description: item.lastMessage,
                date: item.lastMessageAt,
                contentType: .message
            )
        }
        try await CSSearchableIndex.default().indexSearchableItems(searchables)
    }

    /// Index a list of contacts (school directory).
    static func indexContacts<S: Sequence>(_ items: S, schoolId: String) async throws
    where S.Element == (id: String, displayName: String, role: String?) {
        let searchables = items.map { item in
            makeItem(
                identifier: itemIdentifier(type: "contact", id: item.id),
                domain: domainIdentifier(for: schoolId),
                title: item.displayName,
                description: item.role,
                date: nil,
                contentType: .contact
            )
        }
        try await CSSearchableIndex.default().indexSearchableItems(searchables)
    }

    // MARK: - Wipe

    /// Drop every Spotlight entry for a tenant. Call on school switch +
    /// on sign-out so no cross-tenant data lingers in iOS search.
    static func wipe(schoolId: String) async throws {
        try await CSSearchableIndex.default().deleteSearchableItems(
            withDomainIdentifiers: [domainIdentifier(for: schoolId)]
        )
    }

    /// Drop ALL Hogwarts entries (every domain). Use on full sign-out.
    static func wipeAll() async throws {
        try await CSSearchableIndex.default().deleteAllSearchableItems()
    }

    // MARK: - Builder

    private static func makeItem(
        identifier: String,
        domain: String,
        title: String,
        description: String?,
        date: Date?,
        contentType: UTType
    ) -> CSSearchableItem {
        let attrs = CSSearchableItemAttributeSet(contentType: contentType)
        attrs.title = title
        attrs.contentDescription = description
        if let date {
            attrs.contentCreationDate = date
            attrs.contentModificationDate = date
        }
        return CSSearchableItem(
            uniqueIdentifier: identifier,
            domainIdentifier: domain,
            attributeSet: attrs
        )
    }
}
