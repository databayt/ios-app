import Foundation
import SwiftUI

@MainActor
@Observable
final class ChildrenViewModel {
    private(set) var children: [ChildListItem] = []
    private(set) var isLoading = false
    private(set) var lastError: String?

    private let actions: GuardianActions

    init(actions: GuardianActions = .init()) {
        self.actions = actions
    }

    func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            children = try await actions.children().data
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }
}

@MainActor
@Observable
final class ChildDetailViewModel {
    private(set) var detail: ChildDetail?
    private(set) var isLoading = false
    private(set) var lastError: String?

    private let actions: GuardianActions

    init(actions: GuardianActions = .init()) {
        self.actions = actions
    }

    func load(childId: String) async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            detail = try await actions.childDetail(childId: childId)
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }
}
