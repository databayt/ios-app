import Foundation
import Testing
@testable import Hogwarts

@Suite("NotificationPreferencesViewModel.isEnabled")
@MainActor
struct NotificationPreferencesIsEnabledTests {

    @Test("Stored row wins over defaults")
    func storedWinsOverDefaults() {
        let vm = NotificationPreferencesViewModel()
        vm._setStateForTests(
            stored: [row(type: .message, channel: .push, enabled: false)],
            defaults: defaults(push: true)
        )
        // Stored says push for message is OFF — even though default would
        // be ON, the stored value wins.
        #expect(vm.isEnabled(.message, .push) == false)
    }

    @Test("Defaults apply when no stored row exists")
    func defaultsApply() {
        let vm = NotificationPreferencesViewModel()
        vm._setStateForTests(stored: [], defaults: defaults(push: false, email: true, sms: false, inApp: true))
        #expect(vm.isEnabled(.attendance, .push) == false)
        #expect(vm.isEnabled(.attendance, .email) == true)
        #expect(vm.isEnabled(.attendance, .sms) == false)
        #expect(vm.isEnabled(.attendance, .inApp) == true)
    }

    @Test("Channel-specific defaults: SMS defaults off, others on")
    func channelDefaults() {
        let vm = NotificationPreferencesViewModel()
        // No stored, no server defaults at all.
        vm._setStateForTests(stored: [], defaults: nil)
        #expect(vm.isEnabled(.grade, .push) == true)
        #expect(vm.isEnabled(.grade, .email) == true)
        #expect(vm.isEnabled(.grade, .inApp) == true)
        #expect(vm.isEnabled(.grade, .sms) == false)  // SMS opts out by default
    }

    // MARK: - Fixtures

    private func row(type: NotificationCategory, channel: NotificationChannel, enabled: Bool) -> NotificationPreferenceRow {
        NotificationPreferenceRow(
            id: nil, type: type.rawValue, channel: channel.rawValue,
            enabled: enabled, quietHoursStart: nil, quietHoursEnd: nil,
            digestEnabled: nil, digestFrequency: nil
        )
    }

    private func defaults(push: Bool? = nil, email: Bool? = nil, sms: Bool? = nil, inApp: Bool? = nil) -> NotificationPreferenceDefaults {
        NotificationPreferenceDefaults(
            inApp: inApp, email: email, push: push, sms: sms,
            quietHoursStart: nil, quietHoursEnd: nil
        )
    }
}

extension NotificationPreferencesViewModel {
    func _setStateForTests(stored: [NotificationPreferenceRow], defaults: NotificationPreferenceDefaults?) {
        self.stored = stored
        self.defaults = defaults
    }
}

@Suite("NotificationCategory + NotificationChannel")
struct NotificationEnumTests {

    @Test("Categories cover the 8 expected types")
    func categoryCount() {
        #expect(NotificationCategory.allCases.count == 8)
    }

    @Test("Channels cover the 4 expected types")
    func channelCount() {
        #expect(NotificationChannel.allCases.count == 4)
    }

    @Test("Channel raw values match backend keys", arguments: [
        (NotificationChannel.push, "push"),
        (.email, "email"),
        (.sms, "sms"),
        (.inApp, "in_app"),  // backend uses snake_case for in-app
    ])
    func channelRawValues(channel: NotificationChannel, expectedRaw: String) {
        #expect(channel.rawValue == expectedRaw)
    }
}
