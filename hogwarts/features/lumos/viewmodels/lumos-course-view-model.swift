import Foundation
import SwiftUI

/// `/lumos/courses/[slug]` — the course page: its chapters, lessons, the
/// reader's progress and its price.
@MainActor
@Observable
final class LumosCourseViewModel {
    private(set) var page: CoursePage?
    private(set) var isLoading = false
    private(set) var isEnrolling = false
    private(set) var lastError: String?
    private(set) var notice: String?
    /// Set when the subject is paid: the app cannot take money, so it sends
    /// the reader to the web's checkout.
    private(set) var needsWebCheckout = false

    /// The chapter the reader has open; the first unfinished one, else all.
    var expandedChapters: Set<String> = []

    private let actions: LumosActions
    private let slug: String

    init(slug: String, actions: LumosActions = .init()) {
        self.slug = slug
        self.actions = actions
    }

    func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            let page = try await actions.course(slug: slug)
            self.page = page
            if expandedChapters.isEmpty {
                expandedChapters = Set(page.chapters.prefix(1).map(\.id))
            }
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }

    func toggleChapter(_ id: String) {
        if expandedChapters.contains(id) { expandedChapters.remove(id) } else { expandedChapters.insert(id) }
    }

    func enroll() async {
        guard let page, !isEnrolling else { return }
        isEnrolling = true
        notice = nil
        defer { isEnrolling = false }
        do {
            _ = try await actions.enroll(courseId: page.id)
            await load()
        } catch LumosError.paymentRequired {
            needsWebCheckout = true
        } catch LumosError.alreadyEnrolled {
            await load()
        } catch {
            lastError = error.localizedDescription
        }
    }
}
