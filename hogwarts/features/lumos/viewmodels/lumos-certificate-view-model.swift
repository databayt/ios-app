import Foundation
import SwiftUI

/// `/lumos/courses/[slug]/certificate` — the certificate the platform issued
/// when the last published lesson was finished. A reader without one gets the
/// truthful "not yet", not a placeholder certificate.
///
/// The href carries the course's slug; the certificate is keyed by its id, so
/// a slug-only entry reads the course page once first.
@MainActor
@Observable
final class LumosCertificateViewModel {
    private(set) var certificate: LumosCertificate?
    private(set) var courseTitle: String?
    private(set) var isLoading = false
    private(set) var isNotFound = false
    private(set) var lastError: String?

    private let actions: LumosActions
    private var courseId: String?
    private let slug: String?

    init(courseId: String? = nil, slug: String? = nil, actions: LumosActions = .init()) {
        self.courseId = courseId
        self.slug = slug
        self.actions = actions
    }

    func load() async {
        isLoading = true
        lastError = nil
        isNotFound = false
        defer { isLoading = false }

        do {
            if courseId == nil, let slug {
                let page = try await actions.course(slug: slug)
                courseId = page.id
                courseTitle = page.title
            }
            guard let courseId else {
                isNotFound = true
                return
            }
            let certificate = try await actions.certificate(courseId: courseId)
            self.certificate = certificate
            courseTitle = courseTitle ?? certificate.courseName
        } catch let error as APIError {
            if case .serverError(404) = error {
                isNotFound = true
            } else {
                lastError = error.localizedDescription
            }
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }
}
