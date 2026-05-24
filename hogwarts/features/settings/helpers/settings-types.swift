import Foundation

enum ThemeMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .system: String(localized: "settings.theme.system")
        case .light:  String(localized: "settings.theme.light")
        case .dark:   String(localized: "settings.theme.dark")
        }
    }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case en
    case ar

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .en: String(localized: "settings.language.english")
        case .ar: String(localized: "settings.language.arabic")
        }
    }
}

struct WallpaperOption: Identifiable, Hashable {
    let id: String
    let assetName: String
    let label: String
}

enum WallpaperCatalog {
    static let defaultId = "home-wallpaper"

    static let options: [WallpaperOption] = [
        WallpaperOption(id: "home-wallpaper", assetName: "home-wallpaper", label: "Default")
    ]

    static func find(_ id: String) -> WallpaperOption {
        options.first { $0.id == id } ?? options[0]
    }
}
