import SwiftUI

// MARK: - SubjectsContent
//
// 2-column grid of subject cards with search, scope (Catalog / Mine),
// and department-chip filter. Tapping a card pushes
// `SubjectDetailView`. Mirrors Android's catalog grid + my-subjects.

struct SubjectsContent: View {
    @State private var viewModel = SubjectsViewModel()
    @Environment(\.locale) private var locale
    @Environment(AuthManager.self) private var authManager

    private let columns = [
        GridItem(.flexible(), spacing: 12, alignment: .top),
        GridItem(.flexible(), spacing: 12, alignment: .top),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                scopePicker
                if !viewModel.departments.isEmpty {
                    departmentChips
                }
                grid
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .overlay { if viewModel.isLoading && viewModel.allItems.isEmpty { ProgressView() } }
        .navigationTitle(Text("subjects.title"))
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $viewModel.search, prompt: Text("subjects.search.prompt"))
        .task {
            // Default scope per role — students/guardians land on "Mine",
            // teachers/admins on "Catalog".
            if viewModel.allItems.isEmpty {
                viewModel.scope = (authManager.role == .student || authManager.role == .guardian)
                    ? .mine : .catalog
                await viewModel.load(locale: locale)
            }
        }
        .refreshable { await viewModel.load(locale: locale) }
    }

    // MARK: - Sub-views

    private var scopePicker: some View {
        Picker("subjects.scope.title", selection: $viewModel.scope) {
            ForEach(SubjectsScope.allCases, id: \.self) { scope in
                Text(scope.label).tag(scope)
            }
        }
        .pickerStyle(.segmented)
    }

    private var departmentChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip(title: Text("subjects.filter.all"), isSelected: viewModel.selectedDepartment == nil) {
                    viewModel.selectedDepartment = nil
                }
                ForEach(viewModel.departments, id: \.self) { dep in
                    chip(title: Text(dep), isSelected: viewModel.selectedDepartment == dep) {
                        viewModel.selectedDepartment = (viewModel.selectedDepartment == dep) ? nil : dep
                    }
                }
            }
        }
    }

    private func chip(title: Text, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            title
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Capsule().fill(isSelected ? Color.accentColor : Color(uiColor: .tertiarySystemFill)))
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    @ViewBuilder
    private var grid: some View {
        let items = viewModel.filteredItems
        if items.isEmpty && !viewModel.isLoading {
            emptyState.padding(.top, 60)
        } else {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(items) { item in
                    NavigationLink(value: SubjectsRoute.detail(id: item.id)) {
                        SubjectCard(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "books.vertical")
                .font(.system(size: 44))
                .foregroundStyle(.tertiary)
            Text(viewModel.scope == .mine
                 ? Text("subjects.empty.mine")
                 : Text("subjects.empty.catalog"))
            .font(.headline)
            Text("subjects.empty.subtitle")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Card

private struct SubjectCard: View {
    let item: CatalogSubjectListItem

    var tint: Color {
        Color(hex: item.color) ?? Color.deterministic(from: item.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            thumbnail
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .clipShape(UnevenRoundedRectangle(
                    topLeadingRadius: 14, topTrailingRadius: 14, style: .continuous
                ))

            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                if let department = item.department, !department.isEmpty {
                    Text(department)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                HStack(spacing: 6) {
                    if let level = item.levelBadge {
                        miniChip(level, color: tint)
                    }
                    if let grade = item.gradeBadge {
                        miniChip(grade, color: .accentOrange)
                    }
                    Spacer(minLength: 0)
                    if let rating = item.averageRating, rating > 0 {
                        ratingPill(rating)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if let chapters = item.totalChapters, chapters > 0 {
                    Text("subjects.card.chapterCount \(chapters)")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(12)
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let url = item.thumbnailUrl, !url.isEmpty {
            AsyncImage(url: URL(string: url)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure, .empty:
                    placeholderTile
                @unknown default:
                    placeholderTile
                }
            }
        } else {
            placeholderTile
        }
    }

    private var placeholderTile: some View {
        ZStack {
            LinearGradient(
                colors: [tint.opacity(0.85), tint.opacity(0.55)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            Image(systemName: "book.closed.fill")
                .font(.system(size: 36))
                .foregroundStyle(.white.opacity(0.85))
        }
    }

    private func miniChip(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Capsule().fill(color.opacity(0.18)))
            .foregroundStyle(color)
    }

    private func ratingPill(_ rating: Double) -> some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
                .font(.caption2)
            Text(rating.formatted(.number.precision(.fractionLength(1))))
                .font(.caption2.weight(.semibold))
        }
        .foregroundStyle(.yellow)
    }
}

// MARK: - Routing

enum SubjectsRoute: Hashable {
    case detail(id: String)
}

#Preview("LTR") {
    NavigationStack {
        SubjectsContent()
            .navigationDestination(for: SubjectsRoute.self) { route in
                if case .detail(let id) = route { SubjectDetailView(id: id) }
            }
    }
    .environment(AuthManager())
}

#Preview("RTL") {
    NavigationStack {
        SubjectsContent()
            .navigationDestination(for: SubjectsRoute.self) { route in
                if case .detail(let id) = route { SubjectDetailView(id: id) }
            }
    }
    .environment(\.layoutDirection, .rightToLeft)
    .environment(AuthManager())
}
