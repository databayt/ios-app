import Foundation
import SwiftUI

@MainActor
@Observable
final class NotificationPreferencesViewModel {
    private(set) var isLoading = false
    private(set) var lastError: String?
    /// Stored backend preferences (can be empty for first-time users).
    private(set) var stored: [NotificationPreferenceRow] = []
    /// Server-side defaults — applied when no stored row exists.
    private(set) var defaults: NotificationPreferenceDefaults?
    /// In-flight save indicator for the toolbar.
    private(set) var isSaving = false

    private let actions: NotificationPreferencesActions

    init(actions: NotificationPreferencesActions = .init()) {
        self.actions = actions
    }

    func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            let response = try await actions.fetch()
            stored = response.data
            defaults = response.defaults
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }

    /// Effective enabled state for a (category, channel) pair.
    func isEnabled(_ category: NotificationCategory, _ channel: NotificationChannel) -> Bool {
        if let row = stored.first(where: { $0.type == category.rawValue && $0.channel == channel.rawValue }) {
            return row.enabled
        }
        // Fall back to server default for that channel; default to true when
        // neither stored nor default is present.
        switch channel {
        case .push:  return defaults?.push ?? true
        case .email: return defaults?.email ?? true
        case .sms:   return defaults?.sms ?? false
        case .inApp: return defaults?.inApp ?? true
        }
    }

    /// Optimistically toggle the local state, then PUT to the server.
    /// On failure the UI re-renders with the stored value so the switch
    /// snaps back — no need for a separate revert path.
    func toggle(_ category: NotificationCategory, _ channel: NotificationChannel, to newValue: Bool) async {
        // Apply locally first for responsiveness.
        replace(category: category, channel: channel, enabled: newValue)
        isSaving = true
        defer { isSaving = false }
        do {
            try await actions.update(preferences: [
                NotificationPreferenceUpdate(
                    type: category.rawValue,
                    channel: channel.rawValue,
                    enabled: newValue
                )
            ])
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
            // Re-fetch to recover authoritative state.
            await load()
        }
    }

    private func replace(category: NotificationCategory, channel: NotificationChannel, enabled: Bool) {
        let key = (category.rawValue, channel.rawValue)
        if let index = stored.firstIndex(where: { $0.type == key.0 && $0.channel == key.1 }) {
            let prior = stored[index]
            stored[index] = NotificationPreferenceRow(
                id: prior.id,
                type: prior.type,
                channel: prior.channel,
                enabled: enabled,
                quietHoursStart: prior.quietHoursStart,
                quietHoursEnd: prior.quietHoursEnd,
                digestEnabled: prior.digestEnabled,
                digestFrequency: prior.digestFrequency
            )
        } else {
            stored.append(NotificationPreferenceRow(
                id: nil,
                type: key.0,
                channel: key.1,
                enabled: enabled,
                quietHoursStart: nil,
                quietHoursEnd: nil,
                digestEnabled: nil,
                digestFrequency: nil
            ))
        }
    }
}
