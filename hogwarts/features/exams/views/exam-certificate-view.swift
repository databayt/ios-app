import SwiftUI

// MARK: - ExamCertificateView
//
// Celebratory share-able certificate view. Shows hero (icon + exam title +
// student name in active locale) + score/grade/rank chips + verification
// info + open-PDF button. Share button exports as PNG via `ImageRenderer`.

struct ExamCertificateView: View {
    let examId: String

    @State private var certificate: ExamCertificate?
    @State private var lastError: String?
    @State private var renderedShareImage: ShareImage?
    @State private var pdfURL: PDFLink?

    @Environment(\.locale) private var locale
    private let actions = ExamsActions()

    var body: some View {
        Group {
            if let cert = certificate {
                content(for: cert)
            } else if let error = lastError {
                errorState(error)
            } else {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(Text("certificate.title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let cert = certificate {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        renderedShareImage = ShareImage(uiImage: render(certificate: cert))
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accessibilityLabel(Text("certificate.share"))
                }
            }
        }
        .sheet(item: $renderedShareImage) { image in
            ActivityView(items: [image.uiImage])
        }
        .sheet(item: $pdfURL) { link in
            SafariView(url: link.url).ignoresSafeArea()
        }
        .task { await load() }
        .refreshable { await load() }
    }

    // MARK: - Content

    private func content(for cert: ExamCertificate) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                certificateCard(for: cert)
                    .padding(.horizontal, 16)
                detailsCard(for: cert)
                    .padding(.horizontal, 16)
                if let urlString = cert.certificateUrl, let url = URL(string: urlString) {
                    Button {
                        pdfURL = PDFLink(url: url)
                    } label: {
                        Label(String(localized: "certificate.openPDF"), systemImage: "doc.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 16)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
    }

    // MARK: - Certificate card

    private func certificateCard(for cert: ExamCertificate) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "rosette")
                .font(.system(size: 64, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.top, 8)

            Text("certificate.heading")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.85))
                .textCase(.uppercase)
                .tracking(2)

            Text(cert.displayName(for: locale))
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Text("certificate.subtitle")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))

            Text(cert.examTitle)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)

            HStack(spacing: 14) {
                if let grade = cert.grade, !grade.isEmpty {
                    chip(label: grade, systemImage: "star.fill")
                }
                if let score = cert.score {
                    chip(label: String(format: "%.0f", score), systemImage: "number")
                }
                if let rank = cert.rank {
                    chip(label: "#\(rank)", systemImage: "medal")
                }
            }

            Text("certificate.issuedOn \(cert.issuedAt.formatted(date: .long, time: .omitted))")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.75))
                .padding(.top, 4)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.07, green: 0.18, blue: 0.45),
                    Color(red: 0.30, green: 0.10, blue: 0.55)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 16, y: 8)
    }

    private func chip(label: String, systemImage: String) -> some View {
        Label(label, systemImage: systemImage)
            .labelStyle(.titleAndIcon)
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(.white.opacity(0.15)))
            .foregroundStyle(.white)
    }

    // MARK: - Details

    private func detailsCard(for cert: ExamCertificate) -> some View {
        VStack(spacing: 0) {
            if let number = cert.certificateNumber, !number.isEmpty {
                row(label: "certificate.field.number", value: number, monospaced: true)
                divider
            }
            if let code = cert.verificationCode, !code.isEmpty {
                row(label: "certificate.field.verificationCode", value: code, monospaced: true)
                divider
            }
            if let url = cert.verificationUrl, !url.isEmpty {
                Link(destination: URL(string: url) ?? URL(string: "https://databayt.org")!) {
                    HStack {
                        Text("certificate.field.verifyOnline").foregroundStyle(.secondary)
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .foregroundStyle(.tint)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .font(.callout)
                }
                divider
            }
            if let expires = cert.expiresAt {
                row(label: "certificate.field.expires",
                    value: expires.formatted(date: .abbreviated, time: .omitted))
            }
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func row(label: LocalizedStringResource, value: String, monospaced: Bool = false) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary)
            Spacer(minLength: 12)
            Text(value)
                .font(monospaced ? .callout.monospaced() : .callout)
                .multilineTextAlignment(.trailing)
        }
        .font(.callout)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    private var divider: some View { Divider().padding(.leading, 14) }

    // MARK: - Errors

    private func errorState(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "rosette")
                .font(.system(size: 44))
                .foregroundStyle(.tertiary)
            Text("certificate.notAvailable.title").font(.headline)
            Text("certificate.notAvailable.body")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Text(message)
                .font(.caption2)
                .foregroundStyle(.tertiary)
            Button(String(localized: "common.retry")) { Task { await load() } }
                .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Loading

    private func load() async {
        do {
            // Reuse the exam result endpoint until certificate data is widely
            // returned — the certificate route returns 404 for exams that
            // don't have one yet, which we surface as an empty state.
            certificate = try await fetchCertificate()
            lastError = nil
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }

    /// Direct fetch via APIClient — kept here (not in `ExamsActions`) so the
    /// certificate model stays scoped to this view module.
    private func fetchCertificate() async throws -> ExamCertificate {
        try await APIClient.shared.get(
            "/mobile/exams/\(examId)/certificate",
            as: ExamCertificate.self
        )
    }

    // MARK: - Render

    private func render(certificate: ExamCertificate) -> UIImage {
        let renderer = ImageRenderer(content:
            certificateCard(for: certificate)
                .frame(width: 360)
                .padding(20)
                .background(Color(uiColor: .systemGroupedBackground))
                .environment(\.locale, locale)
        )
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage ?? UIImage()
    }
}

// MARK: - Sheet helpers (file-private)

private struct ShareImage: Identifiable {
    let id = UUID()
    let uiImage: UIImage
}

private struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

import SafariServices
private struct PDFLink: Identifiable {
    let id = UUID()
    let url: URL
}
private struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    func updateUIViewController(_ controller: SFSafariViewController, context: Context) {}
}

#Preview("LTR") { NavigationStack { ExamCertificateView(examId: "preview") } }
#Preview("RTL") {
    NavigationStack { ExamCertificateView(examId: "preview") }
        .environment(\.layoutDirection, .rightToLeft)
}
