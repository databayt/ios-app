import SwiftUI

/// The platform menu — the web sidebar, on the phone.
///
/// Rows are `PlatformNav.visible(role:)`, in the web's order. A row with a
/// native mirror pushes it; a row without one opens the same page on the
/// school's site, so the menu never has a dead entry.
struct PlatformMenuView: View {
    @Environment(AppRouter.self) private var router
    @Environment(AuthManager.self) private var authManager
    @Environment(TenantContext.self) private var tenantContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(\.locale) private var locale

    private var items: [PlatformNavItem] {
        PlatformNav.visible(role: authManager.role, enabledModules: nil)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: authManager.currentUser?.imageUrl ?? "")) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundStyle(.secondary)
                        }
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 2) {
                            Text(authManager.currentUser?.displayName ?? String(localized: "profile.defaultName"))
                                .font(.headline)
                            Text(tenantContext.school?.name ?? String(localized: "menu.schoolFallback"))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section {
                    ForEach(items) { item in
                        Button {
                            open(item)
                        } label: {
                            HStack {
                                Text(LocalizedStringKey(item.titleKey))
                                    .foregroundStyle(.primary)
                                Spacer()
                                if let route = HrefRouter.nativeRoute(forKey: item.key, role: authManager.role) {
                                    Image(systemName: route == .dashboard ? "house" : "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                } else {
                                    Image(systemName: "safari")
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                            }
                        }
                    }
                }

                Section {
                    NavigationLink {
                        WebPageView(href: "/help")
                    } label: {
                        Label(String(localized: "profile.help"), systemImage: "questionmark.circle")
                    }
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label(String(localized: "profile.about"), systemImage: "info.circle")
                    }
                }
            }
            .navigationTitle(Text("nav.menu"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: "common.done")) { dismiss() }
                }
            }
        }
    }

    private func open(_ item: PlatformNavItem) {
        if let route = HrefRouter.nativeRoute(forKey: item.key, role: authManager.role) {
            dismiss()
            router.push(route)
            return
        }
        let lang = locale.language.languageCode?.identifier == "en" ? "en" : "ar"
        if let url = WebHandoff.url(schoolDomain: tenantContext.subdomain, lang: lang, href: item.href) {
            dismiss()
            openURL(url)
        }
    }
}
