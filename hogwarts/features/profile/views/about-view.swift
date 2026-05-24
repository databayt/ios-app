import SwiftUI
import UIKit

// MARK: - AboutView
//
// App identity card: version, build, credits, legal links. Reads version and
// build from `Bundle.main` so they stay in sync with what TestFlight ships
// — no hard-coded version strings to drift.

struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    Image("AppIcon-Display")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 96, height: 96)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
                        // Asset is optional today — fall back to system icon.
                        .opacity(UIImage(named: "AppIcon-Display") == nil ? 0 : 1)
                        .overlay {
                            if UIImage(named: "AppIcon-Display") == nil {
                                Image(systemName: "graduationcap.fill")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.tint)
                            }
                        }
                    Text("Hogwarts")
                        .font(.title2.weight(.semibold))
                    Text(versionLine)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                        .accessibilityLabel(Text("about.version.a11y \(versionLine)"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }

            Section(String(localized: "about.section.product")) {
                LabeledContent(
                    String(localized: "about.tagline.title"),
                    value: String(localized: "about.tagline.value")
                )
                LabeledContent(String(localized: "about.developer"), value: "Databayt")
                LabeledContent(String(localized: "about.copyright"),
                               value: "© \(Calendar.current.component(.year, from: .now)) Databayt")
            }

            Section(String(localized: "about.section.links")) {
                Link(destination: URL(string: "https://databayt.org")!) {
                    Label(String(localized: "about.website"), systemImage: "globe")
                }
                Link(destination: URL(string: "https://databayt.org/legal/privacy")!) {
                    Label(String(localized: "about.privacy"), systemImage: "hand.raised")
                }
                Link(destination: URL(string: "https://databayt.org/legal/terms")!) {
                    Label(String(localized: "about.terms"), systemImage: "doc.text")
                }
                Link(destination: URL(string: "https://github.com/databayt")!) {
                    Label(String(localized: "about.openSource"), systemImage: "chevron.left.forwardslash.chevron.right")
                }
            }

            Section(String(localized: "about.section.acknowledgements")) {
                ForEach(Acknowledgement.all) { ack in
                    Link(destination: ack.url) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(ack.name).font(.body)
                            Text(ack.license)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(Text("profile.about"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var versionLine: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = info?["CFBundleVersion"] as? String ?? "1"
        return String(localized: "about.version.format \(version) \(build)")
    }
}

private struct Acknowledgement: Identifiable {
    let id: String
    let name: String
    let license: String
    let url: URL

    static let all: [Acknowledgement] = [
        .init(id: "google-signin", name: "GoogleSignIn-iOS",
              license: "Apache 2.0",
              url: URL(string: "https://github.com/google/GoogleSignIn-iOS")!),
        .init(id: "facebook-sdk", name: "Facebook iOS SDK",
              license: "MIT",
              url: URL(string: "https://github.com/facebook/facebook-ios-sdk")!),
        .init(id: "sf-symbols", name: "SF Symbols",
              license: "Apple",
              url: URL(string: "https://developer.apple.com/sf-symbols/")!)
    ]
}

#Preview("LTR") {
    NavigationStack { AboutView() }
}

#Preview("RTL") {
    NavigationStack { AboutView() }
        .environment(\.layoutDirection, .rightToLeft)
}
