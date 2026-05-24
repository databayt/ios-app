import SwiftUI
import UIKit

// MARK: - IDCardContent
//
// Vertical, card-shaped digital school ID. Composes:
//  • Top header: school logo + school name
//  • Hero photo with role chip overlay
//  • Identity block: name + role-derived subtitle (grade·section / dept / position)
//  • Metadata grid: ID number, blood group, email
//  • Footer barcode (Code 128, scanned at school gate / library checkout)
//  • Share affordance — exports the card as a PNG via UIGraphicsImageRenderer.
//
// Mirrors Android's `idcard` feature.

struct IDCardContent: View {
    @State private var viewModel = IDCardViewModel()
    @Environment(\.locale) private var locale
    @Environment(\.colorScheme) private var colorScheme
    @State private var renderedShareImage: ShareImage?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let card = viewModel.card {
                    cardView(for: card)
                        .padding(.horizontal, 16)
                } else if viewModel.lastError != nil {
                    errorState
                } else {
                    ProgressView()
                        .padding(.top, 60)
                }
            }
            .padding(.vertical, 16)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(Text("idcard.title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let card = viewModel.card {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        renderedShareImage = ShareImage(uiImage: render(card: card))
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accessibilityLabel(Text("idcard.share"))
                }
            }
        }
        .sheet(item: $renderedShareImage) { image in
            ActivityView(items: [image.uiImage])
                .presentationDetents([.medium, .large])
        }
        .task { if viewModel.card == nil { await viewModel.load() } }
        .refreshable { await viewModel.load() }
    }

    // MARK: - Card

    private func cardView(for card: IDCardResponse) -> some View {
        VStack(spacing: 0) {
            schoolHeader(school: card.school)
            heroSection(user: card.user, school: card.school)
            identityBlock(user: card.user)
            metadataGrid(user: card.user)
            barcodeFooter(user: card.user)
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(.white.opacity(0.06), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.10), radius: 16, x: 0, y: 8)
    }

    // MARK: - Sections

    private func schoolHeader(school: IDCardSchool?) -> some View {
        HStack(spacing: 10) {
            if let url = school?.logoUrl, let parsed = URL(string: url) {
                AsyncImage(url: parsed) { phase in
                    if case .success(let image) = phase {
                        image.resizable().scaledToFit()
                    } else {
                        defaultLogo
                    }
                }
                .frame(width: 28, height: 28)
            } else {
                defaultLogo.frame(width: 28, height: 28)
            }
            Text(school?.displayName(for: locale) ?? String(localized: "idcard.school.unknown"))
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
            Spacer()
            Text("idcard.label")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            UnevenRoundedRectangle(
                topLeadingRadius: 24,
                topTrailingRadius: 24,
                style: .continuous
            )
            .fill(LinearGradient(
                colors: [.accentBlue.opacity(0.18), .accentBlue.opacity(0.05)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            ))
        )
    }

    private var defaultLogo: some View {
        Image(systemName: "graduationcap.fill")
            .font(.title3)
            .foregroundStyle(.tint)
    }

    private func heroSection(user: IDCardUser, school: IDCardSchool?) -> some View {
        HStack(spacing: 16) {
            photoView(for: user)
                .frame(width: 86, height: 86)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(.white.opacity(0.18), lineWidth: 1)
                )
            VStack(alignment: .leading, spacing: 6) {
                roleChip(for: user)
                Text(user.fullName)
                    .font(.title3.weight(.bold))
                    .lineLimit(2)
                    .accessibilityAddTraits(.isHeader)
                Text(user.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
    }

    @ViewBuilder
    private func photoView(for user: IDCardUser) -> some View {
        if let url = user.photoUrl, let parsed = URL(string: url) {
            AsyncImage(url: parsed) { phase in
                switch phase {
                case .success(let image): image.resizable().scaledToFill()
                default: photoPlaceholder
                }
            }
        } else {
            photoPlaceholder
        }
    }

    private var photoPlaceholder: some View {
        ZStack {
            LinearGradient(
                colors: [.accentBlue.opacity(0.55), .accentPurple.opacity(0.45)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundStyle(.white.opacity(0.85))
        }
    }

    private func roleChip(for user: IDCardUser) -> some View {
        Label(user.roleKind.displayName, systemImage: roleIcon(user.roleKind))
            .labelStyle(.titleAndIcon)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Capsule().fill(roleColor(user.roleKind).opacity(0.15)))
            .foregroundStyle(roleColor(user.roleKind))
    }

    private func identityBlock(user: IDCardUser) -> some View {
        Divider().padding(.horizontal, 18)
    }

    private func metadataGrid(user: IDCardUser) -> some View {
        let rows: [(LocalizedStringResource, String?)] = [
            ("idcard.field.idNumber", user.idNumber),
            ("idcard.field.bloodGroup", user.bloodGroup),
            ("idcard.field.email", user.email),
        ].compactMap { (key, value) in
            guard let v = value, !v.isEmpty else { return nil }
            return (key, v)
        }

        return VStack(spacing: 0) {
            ForEach(rows.indices, id: \.self) { i in
                let (key, value) = rows[i]
                HStack {
                    Text(key)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer(minLength: 12)
                    Text(value ?? "")
                        .font(.callout.weight(.medium))
                        .monospacedDigit()
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                if i < rows.count - 1 {
                    Divider().padding(.leading, 18)
                }
            }
        }
    }

    private func barcodeFooter(user: IDCardUser) -> some View {
        VStack(spacing: 6) {
            if let barcode = viewModel.barcodeImage(for: user.idNumber) {
                Image(uiImage: barcode)
                    .interpolation(.none)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .accessibilityLabel(Text("idcard.barcode.a11y"))
            } else {
                Text("idcard.barcode.unavailable")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 16)
            }
            if let id = user.idNumber {
                Text(id)
                    .font(.caption2.monospaced())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 18)
    }

    // MARK: - Errors

    private var errorState: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundStyle(.orange)
            Text("idcard.loadFailed").font(.headline)
            if let message = viewModel.lastError {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            Button(String(localized: "idcard.retry")) {
                Task { await viewModel.load() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    // MARK: - Share

    /// Render the entire card as a PNG so users can share it via Messages,
    /// Mail, or Files. Uses `ImageRenderer` (iOS 16+) which captures any
    /// SwiftUI view at the device's `displayScale`.
    private func render(card: IDCardResponse) -> UIImage {
        let renderer = ImageRenderer(content:
            cardView(for: card)
                .frame(width: 360)
                .padding()
                .background(Color(uiColor: .systemGroupedBackground))
                .environment(\.locale, locale)
        )
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage ?? UIImage()
    }

    // MARK: - Role styling helpers

    private func roleIcon(_ role: UserRole) -> String {
        switch role {
        case .student:    "graduationcap.fill"
        case .teacher:    "book.fill"
        case .guardian:   "person.2.fill"
        case .admin, .developer: "shield.fill"
        case .accountant: "dollarsign.circle.fill"
        case .staff, .user: "person.fill"
        }
    }

    private func roleColor(_ role: UserRole) -> Color {
        switch role {
        case .student:    .accentBlue
        case .teacher:    .accentPurple
        case .guardian:   .accentGreen
        case .admin, .developer: .accentRed
        case .accountant: .accentOrange
        case .staff, .user: .appleGray1
        }
    }
}

// MARK: - ShareSheet bridge

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

#Preview("LTR") { NavigationStack { IDCardContent() } }
#Preview("RTL") {
    NavigationStack { IDCardContent() }
        .environment(\.layoutDirection, .rightToLeft)
}
