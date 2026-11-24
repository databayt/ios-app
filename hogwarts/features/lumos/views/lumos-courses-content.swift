import SwiftUI

/// `/lumos/courses` — browse one grade at a time, or search the whole catalog.
struct LumosCoursesContent: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel = LumosCoursesViewModel()
    @State private var isSearchPresented = false

    private let columns = [
        GridItem(.flexible(), spacing: 12, alignment: .top),
        GridItem(.flexible(), spacing: 12, alignment: .top),
    ]

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.page == nil {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.lastError, viewModel.page == nil {
                ErrorStateView(error: LoadError(message: error)) {
                    Task { await viewModel.loadBrowse() }
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        gradeChips
                        recommendedShelf
                        othersGrid
                    }
                    .padding(.bottom, 32)
                }
                .refreshable { await viewModel.loadBrowse() }
            }
        }
        .navigationTitle(Text("lumos.browse"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isSearchPresented = true
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .accessibilityLabel(String(localized: "common.search"))
            }
        }
        .sheet(isPresented: $isSearchPresented) {
            LumosSearchSheet(viewModel: viewModel)
        }
        .task {
            guard viewModel.page == nil else { return }
            await viewModel.loadBrowse()
        }
    }

    // MARK: - Grade

    private var grades: [Int] {
        let shelves = viewModel.page?.shelves.map(\.grade) ?? []
        let unique = Set(shelves).sorted()
        return unique.isEmpty ? Array(1...12) : unique
    }

    private var gradeChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(grades, id: \.self) { grade in
                    let isSelected = viewModel.effectiveGrade == grade
                    Button {
                        viewModel.selectGrade(grade)
                    } label: {
                        Text(String(localized: "lumos.grade \(grade)"))
                            .font(.subheadline.weight(isSelected ? .semibold : .regular))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                isSelected ? Color.hogwartsPrimary : Color(uiColor: .secondarySystemGroupedBackground),
                                in: Capsule()
                            )
                            .foregroundStyle(isSelected ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 8)
    }

    // MARK: - Recommended

    @ViewBuilder
    private var recommendedShelf: some View {
        if !viewModel.recommended.isEmpty {
            LumosShelf(title: String(localized: "lumos.recommended")) {
                ForEach(viewModel.recommended) { course in
                    NavigationLink(value: AppRoute.lumosCourse(slug: course.slug)) {
                        LumosCourseCard(course: course)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - The rest

    @ViewBuilder
    private var othersGrid: some View {
        if !viewModel.others.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(String(localized: "lumos.allCourses"))
                        .font(.title3.bold())
                    Spacer()
                    Text(String(localized: "lumos.courseCount \(viewModel.others.count)"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)

                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(viewModel.visibleOthers) { course in
                        NavigationLink(value: AppRoute.lumosCourse(slug: course.slug)) {
                            LumosCourseCard(course: course, width: nil)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)

                if viewModel.hasMoreOthers {
                    Button {
                        viewModel.seeMoreOthers()
                    } label: {
                        Text(String(localized: "lumos.seeMore"))
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(uiColor: .secondarySystemGroupedBackground), in: Capsule())
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 16)
                }
            }
        } else if viewModel.recommended.isEmpty {
            EmptyStateView(
                title: String(localized: "lumos.empty.title"),
                message: String(localized: "lumos.empty.message"),
                systemImage: "books.vertical"
            )
            .frame(minHeight: 280)
        }
    }
}

// MARK: - Search sheet

/// The sheet's two faces: the shelf while the box is empty, the typeahead
/// while it is not. Submitting leaves the sheet for the course.
struct LumosSearchSheet: View {
    let viewModel: LumosCoursesViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    var body: some View {
        NavigationStack {
            List {
                if query.trimmingCharacters(in: .whitespaces).isEmpty {
                    if viewModel.isLoadingSuggestions {
                        HStack {
                            ProgressView()
                            Text(String(localized: "common.loading"))
                                .foregroundStyle(.secondary)
                        }
                    }
                    Section(String(localized: "lumos.featured")) {
                        ForEach(viewModel.featured) { course in
                            row(course)
                        }
                    }
                } else if viewModel.isLoadingSuggestions {
                    HStack {
                        ProgressView()
                        Text(String(localized: "common.loading"))
                            .foregroundStyle(.secondary)
                    }
                } else if viewModel.typeahead.isEmpty {
                    Text(String(localized: "lumos.search.empty"))
                        .foregroundStyle(.secondary)
                } else {
                    Section {
                        ForEach(viewModel.typeahead) { course in
                            row(course)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(Text("common.search"))
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $query, prompt: Text("lumos.search.prompt"))
            .onChange(of: query) { _, value in
                viewModel.onTypeahead(value)
            }
            .onSubmit(of: .search) {
                Task { await viewModel.submitSearch(query) }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: "common.close")) { dismiss() }
                }
            }
            .task { await viewModel.sheetOpened() }
            .navigationDestination(for: AppRoute.self) { route in
                AppRouteView(route: route)
            }
        }
    }

    private func row(_ course: CatalogCourse) -> some View {
        NavigationLink(value: AppRoute.lumosCourse(slug: course.slug)) {
            HStack(spacing: 12) {
                LumosArtwork(url: course.imageUrl, color: course.color, seed: course.id)
                    .frame(width: 64, height: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text(course.title)
                        .font(.subheadline.weight(.medium))
                        .lineLimit(2)
                    if let grade = course.grades.first {
                        Text(String(localized: "lumos.grade \(grade)"))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
