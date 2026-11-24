import SwiftUI

/// `/lumos/courses/[slug]/certificate` — the certificate, or the truthful
/// "not yet" for a course the reader has not finished.
struct LumosCertificateContent: View {
    let slug: String

    @Environment(TenantContext.self) private var tenantContext
    @Environment(AppRouter.self) private var router
    @State private var viewModel: LumosCertificateViewModel

    init(slug: String) {
        self.slug = slug
        _viewModel = State(initialValue: LumosCertificateViewModel(slug: slug))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let certificate = viewModel.certificate {
                ScrollView {
                    VStack(spacing: 20) {
                        card(certificate)
                        if let url = verificationURL(certificate) {
                            ShareLink(item: url) {
                                Label(String(localized: "lumos.certificate.share"), systemImage: "square.and.arrow.up")
                                    .font(.subheadline.weight(.semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.hogwartsPrimary, in: Capsule())
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 24)
                }
            } else if viewModel.isNotFound {
                EmptyStateView(
                    title: String(localized: "lumos.certificate.none.title"),
                    message: String(localized: "lumos.certificate.none.message"),
                    systemImage: "rosette"
                )
                .frame(maxHeight: .infinity)
            } else {
                ErrorStateView(error: LoadError(message: viewModel.lastError ?? String(localized: "error.title"))) {
                    Task { await viewModel.load() }
                }
            }
        }
        .navigationTitle(Text("lumos.certificate"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.isMenuPresented = true
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
                .accessibilityLabel(String(localized: "nav.menu"))
            }
        }
        .task {
            guard viewModel.certificate == nil, !viewModel.isNotFound else { return }
            await viewModel.load()
        }
    }

    // MARK: - Card

    private func card(_ certificate: LumosCertificate) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "rosette")
                .font(.system(size: 44))
                .foregroundStyle(Color.hogwartsSecondary)

            Text(String(localized: "lumos.certificate.ofCompletion"))
                .font(.caption.weight(.semibold))
                .textCase(.uppercase)
                .foregroundStyle(.secondary)

            Text(certificate.studentName)
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            Text(String(localized: "lumos.certificate.body"))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(certificate.courseName)
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)

            if let date = completedDate(certificate) {
                Text(date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Divider().padding(.horizontal, 24)

            VStack(spacing: 4) {
                Text(String(localized: "lumos.certificate.verification"))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(certificate.verificationCode)
                    .font(.footnote.monospaced().weight(.semibold))
                    .textSelection(.enabled)
            }

            if let school = tenantContext.school?.name, !school.isEmpty {
                Text(school)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.hogwartsSecondary.opacity(0.35), lineWidth: 1)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Helpers

    private func completedDate(_ certificate: LumosCertificate) -> String? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = formatter.date(from: certificate.completedAt)
            ?? ISO8601DateFormatter().date(from: certificate.completedAt)
        guard let date else { return nil }
        return date.formatted(date: .long, time: .omitted)
    }

    /// The one page that proves the certificate: the school's own course page.
    private func verificationURL(_ certificate: LumosCertificate) -> URL? {
        WebHandoff.url(
            schoolDomain: tenantContext.subdomain,
            lang: Locale.current.language.languageCode?.identifier == "en" ? "en" : "ar",
            href: "/lumos/courses/\(slug)"
        )
    }
}
