import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class SettingsViewModel {
    @ObservationIgnored @AppStorage("app.themeMode") private var storedTheme: String = ThemeMode.system.rawValue
    @ObservationIgnored @AppStorage("app.language") private var storedLanguage: String = AppLanguage.en.rawValue
    @ObservationIgnored @AppStorage("app.notificationsEnabled") private var storedNotifications: Bool = true
    @ObservationIgnored @AppStorage("app.wallpaperId") private var storedWallpaperId: String = WallpaperCatalog.defaultId

    var themeMode: ThemeMode {
        get { ThemeMode(rawValue: storedTheme) ?? .system }
        set { storedTheme = newValue.rawValue }
    }

    var language: AppLanguage {
        get { AppLanguage(rawValue: storedLanguage) ?? .en }
        set { storedLanguage = newValue.rawValue }
    }

    var notificationsEnabled: Bool {
        get { storedNotifications }
        set { storedNotifications = newValue }
    }

    var wallpaperId: String {
        get { storedWallpaperId }
        set { storedWallpaperId = newValue }
    }

    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
