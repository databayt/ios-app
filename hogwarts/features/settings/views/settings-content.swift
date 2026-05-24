import SwiftUI

struct SettingsContent: View {
    @State private var viewModel = SettingsViewModel()
    @State private var showLogoutAlert = false
    @State private var showWallpaperPicker = false

    let onNavigateToProfile: () -> Void
    let onLogout: () -> Void

    var body: some View {
        Form {
            Section("settings.section.account") {
                Button(action: onNavigateToProfile) {
                    HStack {
                        Text("settings.profile").foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.right").foregroundStyle(.secondary)
                    }
                }
            }

            Section("settings.section.appearance") {
                Picker("settings.theme", selection: $viewModel.themeMode) {
                    ForEach(ThemeMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }

                Picker("settings.language", selection: $viewModel.language) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                }

                Button {
                    showWallpaperPicker = true
                } label: {
                    HStack {
                        Text("settings.wallpaper").foregroundStyle(.primary)
                        Spacer()
                        Image(WallpaperCatalog.find(viewModel.wallpaperId).assetName)
                            .resizable()
                            .frame(width: 22, height: 32)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
            }

            Section("settings.section.notifications") {
                Toggle("settings.push", isOn: $viewModel.notificationsEnabled)
            }

            Section("settings.section.about") {
                HStack {
                    Text("settings.version")
                    Spacer()
                    Text(viewModel.appVersion).foregroundStyle(.secondary)
                }
            }

            Section {
                Button(role: .destructive) {
                    showLogoutAlert = true
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("settings.logout")
                    }
                }
            }
        }
        .navigationTitle("settings.title")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showWallpaperPicker) {
            WallpaperPickerView(selectedId: $viewModel.wallpaperId)
        }
        .alert("settings.logout.title", isPresented: $showLogoutAlert) {
            Button("settings.cancel", role: .cancel) {}
            Button("settings.logout.confirm", role: .destructive, action: onLogout)
        } message: {
            Text("settings.logout.message")
        }
        .environment(\.layoutDirection, viewModel.language == .ar ? .rightToLeft : .leftToRight)
        .preferredColorScheme(
            viewModel.themeMode == .system ? nil :
            (viewModel.themeMode == .dark ? .dark : .light)
        )
    }
}
