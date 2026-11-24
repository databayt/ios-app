import SafariServices
import SwiftUI

/// In-app browser for the web-only pages the app links to.
struct InAppBrowserView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = false
        let controller = SFSafariViewController(url: url, configuration: configuration)
        controller.preferredControlTintColor = UIColor(Color.hogwartsPrimary)
        return controller
    }

    func updateUIViewController(_ controller: SFSafariViewController, context: Context) {}
}

/// A native screen that shows one web page, for the "Help" and "About" rows.
struct WebPageView: View {
    let href: String
    @Environment(TenantContext.self) private var tenantContext
    @Environment(\.locale) private var locale

    private var url: URL? {
        WebHandoff.url(
            schoolDomain: tenantContext.subdomain,
            lang: locale.language.languageCode?.identifier == "en" ? "en" : "ar",
            href: href
        )
    }

    var body: some View {
        Group {
            if let url {
                InAppBrowserView(url: url).ignoresSafeArea()
            } else {
                ContentUnavailableView(
                    "common.error",
                    systemImage: "safari",
                    description: Text("web.unavailable")
                )
            }
        }
        .navigationTitle(Text("web.page"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// About: what the app is, which build this is, and the school's links.
struct AboutView: View {
    @Environment(\.locale) private var locale
    @Environment(TenantContext.self) private var tenantContext

    private var version: String {
        let short = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "—"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "—"
        return "\(short) (\(build))"
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 52))
                        .foregroundStyle(Color.hogwartsPrimary)
                    Text("app.name")
                        .font(.title2.bold())
                    Text("about.tagline")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            }

            Section(String(localized: "about.build")) {
                LabeledContent(String(localized: "settings.version"), value: version)
                LabeledContent(String(localized: "about.platform"), value: "iOS")
            }

            Section(String(localized: "about.legal")) {
                if let privacy = WebHandoff.url(schoolDomain: tenantContext.subdomain, lang: lang, href: "/privacy") {
                    Link(destination: privacy) {
                        Label(String(localized: "about.privacy"), systemImage: "hand.raised")
                    }
                }
                if let terms = WebHandoff.url(schoolDomain: tenantContext.subdomain, lang: lang, href: "/terms") {
                    Link(destination: terms) {
                        Label(String(localized: "about.terms"), systemImage: "doc.text")
                    }
                }
            }
        }
        .navigationTitle(Text("about.title"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var lang: String {
        locale.language.languageCode?.identifier == "en" ? "en" : "ar"
    }
}
