import AVKit
import SwiftUI

/// `/lumos/courses/[slug]/[lessonId]` — the player, the lesson's own words, its
/// quiz, its resources, and the siblings either side of it.
struct LumosLessonContent: View {
    let courseSlug: String
    let lessonId: String

    @Environment(AppRouter.self) private var router
    @State private var viewModel: LumosLessonViewModel
    @State private var player: AVPlayer?
    /// A resource the reader tapped, shown in the app's own browser.
    @State private var browser: BrowserTarget?

    init(courseSlug: String, lessonId: String) {
        self.courseSlug = courseSlug
        self.lessonId = lessonId
        _viewModel = State(initialValue: LumosLessonViewModel(courseSlug: courseSlug, lessonId: lessonId))
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
        .navigationTitle(Text("lumos.lesson"))
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
        .onChange(of: viewModel.playURL) { _, _ in
            makePlayer()
        }
        .sheet(item: $browser) { target in
            NavigationStack {
                InAppBrowserView(url: target.url)
                    .ignoresSafeArea()
                    .navigationTitle(Text("lumos.resources"))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(String(localized: "common.done")) { browser = nil }
                        }
                    }
            }
        }
    }

    // MARK: - Page

    private func content(_ page: LessonPage) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                player(page)
                titleBlock(page)
                siblings(page)
                quiz(page)
                resources(page)
                footer(page)
            }
            .padding(.bottom, 32)
        }
    }

    // MARK: - Player

    @ViewBuilder
    private func player(_ page: LessonPage) -> some View {
        if let player {
            VideoPlayer(player: player)
                .aspectRatio(16 / 9, contentMode: .fit)
                .background(.black)
        } else {
            LumosArtwork(url: page.thumbnailUrl, color: page.color, seed: page.id, cornerRadius: 0)
                .aspectRatio(16 / 9, contentMode: .fit)
                .overlay {
                    if viewModel.isResolvingMedia {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: "video.slash")
                            .font(.largeTitle)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
        }
    }

    private func makePlayer() {
        guard player == nil, let url = viewModel.playURL else { return }
        player = AVPlayer(url: url)
    }

    // MARK: - Title

    private func titleBlock(_ page: LessonPage) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text([page.chapter.title, page.course.title].filter { !$0.isEmpty }.joined(separator: " • "))
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.hogwartsPrimary)

            Text(page.title)
                .font(.title2.bold())

            if !page.meta.isEmpty {
                Text(page.meta)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if !page.blurb.isEmpty {
                Text(page.blurb)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button {
                Task { await viewModel.markComplete() }
            } label: {
                Label(
                    viewModel.isCompleted
                        ? String(localized: "lumos.completed")
                        : page.labels["mark_complete"] ?? String(localized: "lumos.markComplete"),
                    systemImage: viewModel.isCompleted ? "checkmark.circle.fill" : "circle"
                )
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(
                    viewModel.isCompleted
                        ? Color.hogwartsTertiary.opacity(0.15)
                        : Color(uiColor: .secondarySystemGroupedBackground),
                    in: Capsule()
                )
                .foregroundStyle(viewModel.isCompleted ? Color.hogwartsTertiary : .primary)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isCompleted || viewModel.isCompleting || page.isFallbackVideo)
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }

    // MARK: - Siblings

    @ViewBuilder
    private func siblings(_ page: LessonPage) -> some View {
        if !page.siblings.isEmpty {
            LumosShelf(title: "\(page.labels["more_from"] ?? String(localized: "lumos.moreFrom")) \(page.course.title)") {
                ForEach(page.siblings) { sibling in
                    NavigationLink(value: AppRoute.lumosLesson(
                        courseSlug: page.course.slug,
                        lessonId: sibling.id
                    )) {
                        siblingCard(sibling, labels: page.labels)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func siblingCard(_ sibling: SiblingLesson, labels: [String: String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            LumosArtwork(url: sibling.thumbnailUrl, color: sibling.color, seed: sibling.id)
                .aspectRatio(3 / 2, contentMode: .fit)
                .frame(width: 220)
                .overlay {
                    if sibling.id == lessonId {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Color.hogwartsPrimary, lineWidth: 2)
                    }
                }

            Text(eyebrow(sibling, labels: labels))
                .font(.caption2.weight(.medium))
                .foregroundStyle(.secondary)

            Text(sibling.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .frame(width: 220, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    private func eyebrow(_ sibling: SiblingLesson, labels: [String: String]) -> String {
        if let watched = sibling.watchedMinutes, watched > 0 {
            return "\(watched) \(labels["min_watched"] ?? String(localized: "lumos.minWatched"))"
        }
        let chapter = labels["chapter_short"] ?? "C"
        let lesson = labels["lesson_short"] ?? "L"
        let minutes = labels["min"] ?? String(localized: "lumos.min")
        return "\(chapter)\(sibling.chapterPosition), \(lesson)\(sibling.lessonPosition) · \(sibling.duration ?? 0) \(minutes)"
    }

    // MARK: - Quiz

    @ViewBuilder
    private func quiz(_ page: LessonPage) -> some View {
        if !page.quiz.isEmpty {
            VStack(alignment: .leading, spacing: 14) {
                Text(page.labels["quiz"] ?? String(localized: "lumos.quiz"))
                    .font(.headline)

                ForEach(Array(page.quiz.enumerated()), id: \.element.id) { index, question in
                    questionCard(question, index: index, page: page)
                }

                if let grade = viewModel.grade {
                    quizResult(grade, page: page)
                } else {
                    Button {
                        Task { await viewModel.submitQuiz() }
                    } label: {
                        if viewModel.isSubmitting {
                            ProgressView().frame(maxWidth: .infinity).padding(.vertical, 12)
                        } else {
                            Text(page.labels["quiz_submit"] ?? String(localized: "lumos.quiz.submit"))
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.hogwartsPrimary, in: Capsule())
                                .foregroundStyle(.white)
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(!viewModel.allAnswered || viewModel.isSubmitting)
                    .opacity(viewModel.allAnswered ? 1 : 0.5)
                }

                if let quizError = viewModel.quizError {
                    Text(quizError)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            .padding(16)
            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .padding(.horizontal, 16)
        }
    }

    private func questionCard(_ question: LessonQuizQuestion, index: Int, page: LessonPage) -> some View {
        let verdict = viewModel.verdict(for: question.id)
        let isGraded = viewModel.grade != nil

        return VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 8) {
                Text("\(index + 1).")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(question.text)
                    .font(.subheadline.weight(.medium))
                if let verdict {
                    Image(systemName: verdict.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(verdict.isCorrect ? Color.hogwartsTertiary : .red)
                }
            }

            if viewModel.isTextQuestion(question) {
                TextField(
                    page.labels["quiz_placeholder"] ?? String(localized: "lumos.quiz.placeholder"),
                    text: Binding(
                        get: { viewModel.texts[question.id] ?? "" },
                        set: { viewModel.type($0, for: question.id) }
                    ),
                    axis: .vertical
                )
                .lineLimit(2...4)
                .textFieldStyle(.roundedBorder)
                .disabled(isGraded)

                if let sample = verdict?.sampleAnswer, !sample.isEmpty {
                    Text(sample)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                VStack(spacing: 8) {
                    ForEach(Array((question.choices ?? []).enumerated()), id: \.offset) { choiceIndex, choice in
                        let isChosen = viewModel.choices[question.id] == choiceIndex
                        let isRight = verdict?.correctIndex == choiceIndex
                        Button {
                            guard !isGraded else { return }
                            viewModel.choose(choiceIndex, for: question.id)
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: isChosen ? "largecircle.fill.circle" : "circle")
                                    .foregroundStyle(isChosen ? Color.hogwartsPrimary : .secondary)
                                Text(choice)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                                Spacer(minLength: 0)
                                if isGraded && isRight {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.hogwartsTertiary)
                                }
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                (isGraded && isRight)
                                    ? Color.hogwartsTertiary.opacity(0.12)
                                    : Color(uiColor: .tertiarySystemGroupedBackground),
                                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                if let explanation = verdict?.explanation, !explanation.isEmpty {
                    Text(explanation)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 6)
    }

    private func quizResult(_ grade: QuizGrade, page: LessonPage) -> some View {
        HStack(spacing: 8) {
            Image(systemName: grade.passed ? "checkmark.seal.fill" : "info.circle")
                .foregroundStyle(grade.passed ? Color.hogwartsTertiary : .orange)
            Text(String(localized: "lumos.quiz.score \(grade.score) \(grade.totalQuestions) \(grade.percentage)"))
                .font(.subheadline.weight(.medium))
            Spacer(minLength: 0)
            if grade.syncedToGradebook {
                Text(page.labels["quiz_recorded"] ?? String(localized: "lumos.quiz.recorded"))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(10)
        .background(Color(uiColor: .tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    // MARK: - Resources

    @ViewBuilder
    private func resources(_ page: LessonPage) -> some View {
        if !page.resources.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text(page.labels["resources"] ?? String(localized: "lumos.resources"))
                    .font(.headline)
                    .padding(.horizontal, 16)

                ForEach(page.resources) { resource in
                    Button {
                        Task { await openResource(resource) }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "doc.text")
                                .foregroundStyle(Color.hogwartsPrimary)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(resource.title)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                                if let description = resource.description, !description.isEmpty {
                                    Text(description)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                            }
                            Spacer(minLength: 0)
                            Image(systemName: "arrow.up.forward.square")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(12)
                        .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .disabled(resource.url == nil)
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    private func openResource(_ resource: LumosLessonResource) async {
        guard let url = await viewModel.resourceURL(resource) else { return }
        browser = BrowserTarget(url: url)
    }

    // MARK: - Footer

    private func footer(_ page: LessonPage) -> some View {
        HStack(spacing: 12) {
            if let previous = page.previous {
                NavigationLink(value: AppRoute.lumosLesson(courseSlug: page.course.slug, lessonId: previous.id)) {
                    navLabel("chevron.backward", previous.title, filled: false)
                }
                .buttonStyle(.plain)
            }

            if let next = page.next {
                NavigationLink(value: AppRoute.lumosLesson(courseSlug: page.course.slug, lessonId: next.id)) {
                    navLabel("chevron.forward", next.title, filled: true)
                }
                .buttonStyle(.plain)
            } else {
                NavigationLink(value: AppRoute.lumosCourse(slug: page.course.slug)) {
                    navLabel(
                        "chevron.forward",
                        page.labels["back_to_course"] ?? String(localized: "lumos.backToCourse"),
                        filled: true
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }

    private func navLabel(_ icon: String, _ title: String, filled: Bool) -> some View {
        HStack(spacing: 6) {
            if !filled { Image(systemName: icon).font(.caption) }
            Text(title)
                .font(.subheadline.weight(.medium))
                .lineLimit(1)
            if filled { Image(systemName: icon).font(.caption) }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            filled ? Color.hogwartsPrimary : Color(uiColor: .secondarySystemGroupedBackground),
            in: Capsule()
        )
        .foregroundStyle(filled ? .white : .primary)
    }
}

/// A resolved resource link, presented as a sheet.
private struct BrowserTarget: Identifiable {
    let id = UUID()
    let url: URL
}
