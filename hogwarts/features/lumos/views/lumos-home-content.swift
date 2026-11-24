import SwiftUI

/// `/lumos` — the platform's learning home: what to pick up, what to start, and
/// a shelf for every grade.
struct LumosHomeContent: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel = LumosHomeViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.page.shelves.isEmpty {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.lastError, viewModel.page.shelves.isEmpty {
                ErrorStateView(error: LoadError(message: error)) {
                    Task { await viewModel.load() }
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        hero

                        if let startHere = viewModel.page.startHere {
                            startHereCard(startHere)
                        }

                        if !viewModel.page.continueWatching.isEmpty {
                            LumosShelf(title: String(localized: "lumos.continueWatching")) {
                                ForEach(viewModel.page.continueWatching) { resume in
                                    NavigationLink(value: AppRoute.lumosLesson(
                                        courseSlug: resume.courseSlug,
                                        lessonId: resume.lessonId
                                    )) {
                                        LumosContinueCard(resume: resume)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        ForEach(viewModel.shelves) { shelf in
                            LumosShelf(title: String(localized: "lumos.gradeShelf \(shelf.grade)")) {
                                ForEach(shelf.courses) { course in
                                    NavigationLink(value: AppRoute.lumosCourse(slug: course.slug)) {
                                        LumosCourseCard(course: course)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        if viewModel.shelves.isEmpty {
                            EmptyStateView(
                                title: String(localized: "lumos.empty.title"),
                                message: String(localized: "lumos.empty.message"),
                                systemImage: "sparkles"
                            )
                            .frame(minHeight: 240)
                        }
                    }
                    .padding(.bottom, 32)
                }
                .refreshable { await viewModel.load() }
            }
        }
        .navigationTitle(Text("lumos.title"))
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: AppRoute.lumosCourses) {
                    Image(systemName: "magnifyingglass")
                }
                .accessibilityLabel(String(localized: "lumos.browse"))
            }
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
            guard viewModel.page.shelves.isEmpty else { return }
            await viewModel.load()
        }
    }

    // MARK: - Hero

    private var hero: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "lumos.hero.eyebrow"))
                .font(.caption.weight(.semibold))
                .textCase(.uppercase)
                .foregroundStyle(.white.opacity(0.75))

            Text(String(localized: "lumos.hero.title"))
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text(String(localized: "lumos.hero.body"))
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))

            if let grade = viewModel.page.effectiveGrade {
                Text(String(localized: "lumos.gradeShelf \(grade)"))
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.white.opacity(0.18), in: Capsule())
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.hogwartsPrimary, Color.hogwartsPrimaryDark],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Start here

    private func startHereCard(_ start: StartHereLesson) -> some View {
        NavigationLink(value: AppRoute.lumosLesson(
            courseSlug: start.courseSlug,
            lessonId: start.lessonId
        )) {
            HStack(spacing: 14) {
                LumosArtwork(url: start.thumbnailUrl, color: start.color, seed: start.lessonId)
                    .frame(width: 96, height: 64)
                    .overlay {
                        Image(systemName: "play.fill")
                            .font(.body)
                            .foregroundStyle(.white)
                            .shadow(radius: 2)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(String(localized: "lumos.startHere"))
                        .font(.caption2.weight(.bold))
                        .textCase(.uppercase)
                        .foregroundStyle(Color.hogwartsPrimary)
                    Text(start.lessonTitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    Text([start.courseTitle, start.chapterTitle].filter { !$0.isEmpty }.joined(separator: " · "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)
            }
            .padding(12)
            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .accessibilityElement(children: .combine)
    }
}

/// Wraps a message in the `Error` shape the shared error view takes.
struct LoadError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}
