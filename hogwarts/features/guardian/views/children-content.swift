import SwiftUI

// MARK: - ChildrenContent
//
// List of the guardian's children — each row is a tappable card with the
// child's photo, name, grade·section, and a relationship chip. Tap pushes
// `ChildDetailView`. Mirrors Android's guardian feature root screen.

struct ChildrenContent: View {
    @State private var viewModel = ChildrenViewModel()
    @Environment(\.locale) private var locale

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if viewModel.children.isEmpty && !viewModel.isLoading {
                    emptyState.padding(.top, 60)
                }
                ForEach(viewModel.children) { child in
                    NavigationLink(value: GuardianRoute.child(id: child.id)) {
                        ChildCard(child: child, locale: locale)
                    }
                    .buttonStyle(.plain)
                }
                if let error = viewModel.lastError {
                    errorBanner(error)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .overlay { if viewModel.isLoading && viewModel.children.isEmpty { ProgressView() } }
        .navigationTitle(Text("guardian.title"))
        .navigationBarTitleDisplayMode(.large)
        .task { if viewModel.children.isEmpty { await viewModel.load() } }
        .refreshable { await viewModel.load() }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.2")
                .font(.system(size: 44))
                .foregroundStyle(.tertiary)
            Text("guardian.empty.title").font(.headline)
            Text("guardian.empty.subtitle")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private func errorBanner(_ message: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(String(localized: "guardian.error.title"), systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
            Text(message).font(.caption).foregroundStyle(.secondary)
            Button(String(localized: "guardian.retry")) {
                Task { await viewModel.load() }
            }
            .buttonStyle(.bordered)
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct ChildCard: View {
    let child: ChildListItem
    let locale: Locale

    var body: some View {
        HStack(spacing: 14) {
            avatar
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(.white.opacity(0.18), lineWidth: 1))

            VStack(alignment: .leading, spacing: 4) {
                Text(child.fullName)
                    .font(.body.weight(.semibold))
                if let line = child.classLine {
                    Label(line, systemImage: "book.closed")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if let relationship = child.relationship, !relationship.isEmpty {
                    Text(relationship.capitalized)
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.accentBlue.opacity(0.15)))
                        .foregroundStyle(Color.accentBlue)
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.forward")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var avatar: some View {
        if let url = child.photoUrl, let parsed = URL(string: url) {
            AsyncImage(url: parsed) { phase in
                switch phase {
                case .success(let image): image.resizable().scaledToFill()
                default: placeholder
                }
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        ZStack {
            LinearGradient(
                colors: [.accentBlue.opacity(0.6), .accentPurple.opacity(0.4)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            Image(systemName: "person.fill")
                .font(.title2)
                .foregroundStyle(.white.opacity(0.85))
        }
    }
}

// MARK: - Routing

enum GuardianRoute: Hashable {
    case child(id: String)
    case childAttendance(id: String)
    case childGrades(id: String)
    case childFees(id: String)
    case childTimetable(id: String)
}
