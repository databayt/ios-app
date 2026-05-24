import SwiftUI

// MARK: - SubjectDetailView
//
// Hero (banner or thumbnail) + metadata + chapters → lessons tree.
// Each chapter is a `DisclosureGroup` so the user can drill in without
// leaving the screen. Tapping a lesson is a placeholder hook for the
// future Stream feature.

struct SubjectDetailView: View {
    let id: String

    @State private var detail: CatalogSubjectDetail?
    @State private var isLoading = false
    @State private var lastError: String?
    @State private var expandedChapterID: String?

    @Environment(\.locale) private var locale
    private let actions = SubjectsActions()

    var body: some View {
        Group {
            if let detail {
                content(for: detail)
            } else if let lastError {
                errorState(lastError)
            } else {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(Text(detail?.name ?? String(localized: "subjects.detail.title")))
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
        .refreshable { await load() }
    }

    // MARK: - Content

    private func content(for d: CatalogSubjectDetail) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                hero(for: d)
                if let description = d.description, !description.isEmpty {
                    descriptionCard(description)
                }
                metadataCard(for: d)
                if let chapters = d.chapters, !chapters.isEmpty {
                    chaptersList(chapters, tint: tint(for: d))
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
    }

    private func hero(for d: CatalogSubjectDetail) -> some View {
        ZStack(alignment: .bottomLeading) {
            heroBackground(for: d)
                .frame(height: 200)
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.55)],
                startPoint: .top, endPoint: .bottom
            )
            .frame(height: 200)

            VStack(alignment: .leading, spacing: 6) {
                Text(d.name)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .accessibilityAddTraits(.isHeader)
                if let department = d.department, !department.isEmpty {
                    Text(department)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                }
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.10), radius: 8, y: 4)
    }

    @ViewBuilder
    private func heroBackground(for d: CatalogSubjectDetail) -> some View {
        let url = d.bannerUrl ?? d.thumbnailUrl
        if let urlString = url, let parsed = URL(string: urlString) {
            AsyncImage(url: parsed) { phase in
                switch phase {
                case .success(let image): image.resizable().scaledToFill()
                default: tintBackdrop(for: d)
                }
            }
        } else {
            tintBackdrop(for: d)
        }
    }

    private func tintBackdrop(for d: CatalogSubjectDetail) -> some View {
        LinearGradient(
            colors: [tint(for: d).opacity(0.85), tint(for: d).opacity(0.55)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }

    private func descriptionCard(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("subjects.detail.section.about")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Text(text)
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func metadataCard(for d: CatalogSubjectDetail) -> some View {
        let rows: [(LocalizedStringResource, String)] = [
            ("subjects.detail.field.curriculum", d.curriculum ?? "—"),
            ("subjects.detail.field.country", d.country ?? "—"),
            ("subjects.detail.field.gradeRange", d.gradeRange ?? "—"),
            ("subjects.detail.field.chapters", "\(d.totalChapters ?? 0)"),
            ("subjects.detail.field.lessons", "\(d.totalLessons ?? 0)"),
        ]
        return VStack(spacing: 0) {
            ForEach(rows.indices, id: \.self) { i in
                let (key, value) = rows[i]
                HStack {
                    Text(key)
                        .foregroundStyle(.secondary)
                    Spacer(minLength: 12)
                    Text(value)
                }
                .font(.callout)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                if i < rows.count - 1 {
                    Divider().padding(.leading, 16)
                }
            }
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func chaptersList(_ chapters: [CatalogChapter], tint: Color) -> some View {
        VStack(spacing: 10) {
            HStack {
                Text("subjects.detail.section.chapters")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                Spacer()
                Text("subjects.detail.chapterCount \(chapters.count)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            ForEach(chapters) { chapter in
                chapterRow(chapter, tint: tint)
            }
        }
    }

    private func chapterRow(_ chapter: CatalogChapter, tint: Color) -> some View {
        DisclosureGroup(
            isExpanded: Binding(
                get: { expandedChapterID == chapter.id },
                set: { open in expandedChapterID = open ? chapter.id : nil }
            )
        ) {
            VStack(spacing: 0) {
                ForEach(chapter.lessons ?? []) { lesson in
                    lessonRow(lesson, tint: tint)
                    if lesson.id != chapter.lessons?.last?.id {
                        Divider().padding(.leading, 44)
                    }
                }
            }
            .padding(.top, 6)
        } label: {
            HStack(spacing: 10) {
                Circle()
                    .fill(Color(hex: chapter.color) ?? tint)
                    .frame(width: 10, height: 10)
                VStack(alignment: .leading, spacing: 2) {
                    Text(chapter.name)
                        .font(.subheadline.weight(.semibold))
                    if let count = chapter.totalLessons {
                        Text("subjects.detail.lessonCount \(count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func lessonRow(_ lesson: CatalogLesson, tint: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: lesson.videoCount.map { $0 > 0 } == true ? "play.rectangle.fill" : "doc.text")
                .foregroundStyle(tint)
                .frame(width: 22)
            VStack(alignment: .leading, spacing: 2) {
                Text(lesson.name)
                    .font(.callout)
                if let duration = lesson.formattedDuration {
                    Text(duration)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            Spacer()
            if let resources = lesson.resourceCount, resources > 0 {
                Label("\(resources)", systemImage: "paperclip")
                    .labelStyle(.titleAndIcon)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel(Text("subjects.detail.lesson.resources \(resources)"))
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
    }

    private func tint(for d: CatalogSubjectDetail) -> Color {
        Color(hex: d.color) ?? Color.deterministic(from: d.id)
    }

    // MARK: - Loading / errors

    private func errorState(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundStyle(.orange)
            Text("subjects.detail.loadFailed").font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button(String(localized: "subjects.retry")) {
                Task { await load() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            detail = try await actions.detail(
                id: id,
                languageCode: locale.subjectsApiLanguageCode
            )
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }
}

#Preview("LTR") { NavigationStack { SubjectDetailView(id: "preview") } }
#Preview("RTL") {
    NavigationStack { SubjectDetailView(id: "preview") }
        .environment(\.layoutDirection, .rightToLeft)
}
