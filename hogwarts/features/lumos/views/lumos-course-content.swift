import SwiftUI

/// `/lumos/courses/[slug]` — the subject's page: what the course is, what it
/// holds chapter by chapter, and the one button that moves the reader forward.
struct LumosCourseContent: View {
    let slug: String

    @Environment(AppRouter.self) private var router
    @Environment(TenantContext.self) private var tenantContext
    @Environment(\.openURL) private var openURL
    @Environment(\.locale) private var locale
    @State private var viewModel: LumosCourseViewModel

    init(slug: String) {
        self.slug = slug
        _viewModel = State(initialValue: LumosCourseViewModel(slug: slug))
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.page == nil {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.lastError, viewModel.page == nil {
                ErrorStateView(error: LoadError(message: error)) {
                    Task { await viewModel.load() }
                }
            } else if let page = viewModel.page {
                content(page)
            }
        }
        .navigationTitle(Text("lumos.course"))
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
            guard viewModel.page == nil else { return }
            await viewModel.load()
        }
        .onChange(of: viewModel.needsWebCheckout) { _, needs in
            guard needs else { return }
            openOnWeb()
        }
    }

    // MARK: - Page

    private func content(_ page: CoursePage) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                hero(page)
                progressCard(page)
                objectives(page)
                chapters(page)
                if page.progress?.percent == 100 || page.progress?.completedLessons == page.totalLessons,
                   page.totalLessons > 0 {
                    certificateRow(page)
                }
            }
            .padding(.bottom, 32)
        }
        .refreshable { await viewModel.load() }
    }

    private func hero(_ page: CoursePage) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            LumosArtwork(url: page.imageUrl, color: page.color, seed: page.id, cornerRadius: 20)
                .aspectRatio(16 / 9, contentMode: .fit)

            VStack(alignment: .leading, spacing: 8) {
                Text(page.title)
                    .font(.title2.bold())

                HStack(spacing: 8) {
                    if let school = page.schoolName, !school.isEmpty {
                        Label(school, systemImage: "building.columns")
                    }
                    if page.totalLessons > 0 {
                        Label(String(localized: "lumos.lessonCount \(page.totalLessons)"), systemImage: "list.bullet")
                    }
                    if page.quizCount > 0 {
                        Label(String(localized: "lumos.quizCount \(page.quizCount)"), systemImage: "checkmark.circle")
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                if let description = page.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                actionRow(page)
            }
            .padding(.horizontal, 16)
        }
    }

    @ViewBuilder
    private func actionRow(_ page: CoursePage) -> some View {
        HStack(spacing: 12) {
            if let first = firstUnfinishedLesson(page) {
                NavigationLink(value: AppRoute.lumosLesson(courseSlug: page.slug, lessonId: first.id)) {
                    Label(
                        (page.progress?.completedLessons ?? 0) > 0
                            ? String(localized: "lumos.continue")
                            : String(localized: "lumos.start"),
                        systemImage: "play.fill"
                    )
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.hogwartsPrimary, in: Capsule())
                    .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }

            if !page.isEnrolled {
                Button {
                    Task { await viewModel.enroll() }
                } label: {
                    if viewModel.isEnrolling {
                        ProgressView().frame(maxWidth: .infinity).padding(.vertical, 12)
                    } else {
                        Text(page.isFree
                             ? String(localized: "lumos.enroll.free")
                             : priceLabel(page))
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(uiColor: .secondarySystemGroupedBackground), in: Capsule())
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 4)
    }

    @ViewBuilder
    private func progressCard(_ page: CoursePage) -> some View {
        if let progress = page.progress, progress.totalLessons > 0 {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(String(localized: "lumos.yourProgress"))
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Text(String(localized: "lumos.progress \(progress.percent)"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                LumosProgressBar(value: Double(progress.percent) / 100)
                if progress.remainingMinutes > 0 {
                    Text(String(localized: "lumos.minutesLeft \(progress.remainingMinutes)"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(14)
            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.horizontal, 16)
        }
    }

    @ViewBuilder
    private func objectives(_ page: CoursePage) -> some View {
        if !page.objectives.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(String(localized: "lumos.objectives"))
                    .font(.headline)
                    .padding(.horizontal, 16)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(page.objectives.enumerated()), id: \.offset) { _, objective in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(Color.hogwartsTertiary)
                                .padding(.top, 2)
                            Text(objective)
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private func chapters(_ page: CoursePage) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(localized: "lumos.curriculum"))
                .font(.headline)
                .padding(.horizontal, 16)

            ForEach(Array(page.chapters.enumerated()), id: \.element.id) { index, chapter in
                VStack(alignment: .leading, spacing: 0) {
                    Button {
                        viewModel.toggleChapter(chapter.id)
                    } label: {
                        HStack(spacing: 10) {
                            Text("\(index + 1)")
                                .font(.caption.weight(.bold))
                                .frame(width: 24, height: 24)
                                .background(Color.hogwartsPrimary.opacity(0.12), in: Circle())
                                .foregroundStyle(Color.hogwartsPrimary)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(chapter.title)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                                Text(String(localized: "lumos.lessonCount \(chapter.lessons.count)"))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer(minLength: 0)

                            Image(systemName: viewModel.expandedChapters.contains(chapter.id)
                                  ? "chevron.up" : "chevron.down")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)

                    if viewModel.expandedChapters.contains(chapter.id) {
                        Divider()
                        ForEach(Array(chapter.lessons.enumerated()), id: \.element.id) { position, lesson in
                            NavigationLink(value: AppRoute.lumosLesson(
                                courseSlug: page.slug,
                                lessonId: lesson.id
                            )) {
                                LumosLessonRow(lesson: lesson, position: position + 1, isCurrent: false)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 16)
            }
        }
    }

    private func certificateRow(_ page: CoursePage) -> some View {
        NavigationLink(value: AppRoute.lumosCertificate(slug: page.slug)) {
            HStack(spacing: 12) {
                Image(systemName: "rosette")
                    .font(.title2)
                    .foregroundStyle(Color.hogwartsSecondary)
                VStack(alignment: .leading, spacing: 2) {
                    Text(String(localized: "lumos.certificate"))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(String(localized: "lumos.certificate.hint"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.forward")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.horizontal, 16)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helpers

    private func firstUnfinishedLesson(_ page: CoursePage) -> CoursePageLesson? {
        page.chapters.lazy.flatMap(\.lessons).first
    }

    private func priceLabel(_ page: CoursePage) -> String {
        guard let price = page.price else { return String(localized: "lumos.enroll.free") }
        let formatted = price.formatted(.currency(code: page.currency ?? "USD"))
        return String(localized: "lumos.enroll.paid \(formatted)")
    }

    /// A paid subject is the web's to sell: the app opens its page, where the
    /// school's checkout already lives.
    private func openOnWeb() {
        let lang = locale.language.languageCode?.identifier == "en" ? "en" : "ar"
        guard let url = WebHandoff.url(
            schoolDomain: tenantContext.subdomain,
            lang: lang,
            href: "/lumos/courses/\(slug)"
        ) else { return }
        openURL(url)
    }
}
