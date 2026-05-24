import SwiftUI

// MARK: - ExamDetailView
//
// Hero card (subject + title + type chip + status), schedule section,
// scoring section, instructions, exam settings (proctor mode, shuffle,
// max attempts). The "Take exam" button is intentionally absent — the
// mobile API doesn't yet expose attempt/submit endpoints, so we display
// a clear next-step instead of a dead button.

struct ExamDetailView: View {
    let id: String

    @State private var detail: SchoolExamDetail?
    @State private var lastError: String?
    @Environment(\.locale) private var locale

    private let actions = ExamsActions()

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
        .navigationTitle(Text("exams.detail.title"))
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
        .refreshable { await load() }
    }

    // MARK: - Content

    private func content(for d: SchoolExamDetail) -> some View {
        List {
            Section { hero(for: d).listRowSeparator(.hidden) }

            Section(String(localized: "exams.detail.section.schedule")) {
                if let date = d.examDate {
                    LabeledContent(
                        String(localized: "exams.detail.field.date"),
                        value: date.formatted(.dateTime.weekday(.wide).day().month(.wide).year().locale(locale))
                    )
                }
                if let s = d.startTime, !s.isEmpty {
                    LabeledContent(
                        String(localized: "exams.detail.field.time"),
                        value: d.endTime.map { e in "\(s) – \(e)" } ?? s
                    )
                }
                if let duration = d.formattedDuration {
                    LabeledContent(
                        String(localized: "exams.detail.field.duration"),
                        value: duration
                    )
                }
            }

            Section(String(localized: "exams.detail.section.scoring")) {
                if let total = d.totalMarks {
                    LabeledContent(
                        String(localized: "exams.detail.field.totalMarks"),
                        value: "\(total)"
                    )
                }
                if let passing = d.passingMarks {
                    let pct = d.passingPercent.map {
                        $0.formatted(.percent.precision(.fractionLength(0)))
                    }
                    LabeledContent(
                        String(localized: "exams.detail.field.passingMarks"),
                        value: pct.map { "\(passing) (\($0))" } ?? "\(passing)"
                    )
                }
            }

            if let instructions = d.instructions, !instructions.isEmpty {
                Section(String(localized: "exams.detail.section.instructions")) {
                    Text(instructions)
                        .font(.body)
                }
            }

            settingsSection(for: d)

            Section {
                if d.statusKind == .scheduled || d.statusKind == .inProgress {
                    NavigationLink(value: ExamsRoute.attempt(id: d.id, title: d.title)) {
                        Label(String(localized: "exams.action.startAttempt"),
                              systemImage: "play.circle.fill")
                            .foregroundStyle(.tint)
                    }
                }
                if d.statusKind == .completed {
                    NavigationLink(value: ExamsRoute.certificate(id: d.id)) {
                        Label(String(localized: "exams.action.viewCertificate"),
                              systemImage: "rosette")
                            .foregroundStyle(.tint)
                    }
                }
                takeExamNotice(for: d)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.insetGrouped)
    }

    private func hero(for d: SchoolExamDetail) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Label(d.typeKind.label, systemImage: d.typeKind.systemImage)
                    .labelStyle(.titleAndIcon)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(d.typeKind.color.opacity(0.15)))
                    .foregroundStyle(d.typeKind.color)
                if d.statusKind != .unknown {
                    Label(d.statusKind.label, systemImage: "circle.fill")
                        .labelStyle(.titleAndIcon)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(d.statusKind.color.opacity(0.15)))
                        .foregroundStyle(d.statusKind.color)
                }
            }

            Text(d.title)
                .font(.title2.weight(.bold))
                .accessibilityAddTraits(.isHeader)

            if let subject = d.subjectName, !subject.isEmpty {
                Label(subject, systemImage: "book.closed")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let description = d.description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }

    @ViewBuilder
    private func settingsSection(for d: SchoolExamDetail) -> some View {
        let hasSettings = d.proctorMode != nil
            || d.shuffleQuestions != nil
            || (d.maxAttempts ?? 0) > 0
        if hasSettings {
            Section(String(localized: "exams.detail.section.settings")) {
                if let proctor = d.proctorMode, !proctor.isEmpty {
                    LabeledContent(
                        String(localized: "exams.detail.field.proctorMode"),
                        value: proctor.capitalized
                    )
                }
                if let shuffle = d.shuffleQuestions {
                    LabeledContent(
                        String(localized: "exams.detail.field.shuffle"),
                        value: shuffle
                            ? String(localized: "common.yes")
                            : String(localized: "common.no")
                    )
                }
                if let max = d.maxAttempts, max > 0 {
                    LabeledContent(
                        String(localized: "exams.detail.field.maxAttempts"),
                        value: "\(max)"
                    )
                }
            }
        }
    }

    /// The mobile attempt API isn't live yet — this card explains the
    /// current state instead of offering a dead "Take exam" button.
    private func takeExamNotice(for d: SchoolExamDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(
                d.statusKind == .completed
                    ? String(localized: "exams.notice.completed.title")
                    : String(localized: "exams.notice.takeOnWeb.title"),
                systemImage: d.statusKind == .completed
                    ? "checkmark.seal.fill"
                    : "info.circle.fill"
            )
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(d.statusKind == .completed ? .green : .accentColor)

            Text(d.statusKind == .completed
                 ? "exams.notice.completed.body"
                 : "exams.notice.takeOnWeb.body")
            .font(.callout)
            .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    // MARK: - Errors

    private func errorState(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundStyle(.orange)
            Text("exams.detail.loadFailed").font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button(String(localized: "exams.retry")) {
                Task { await load() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func load() async {
        do {
            detail = try await actions.detail(id: id)
            lastError = nil
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }
}

#Preview("LTR") { NavigationStack { ExamDetailView(id: "preview") } }
#Preview("RTL") {
    NavigationStack { ExamDetailView(id: "preview") }
        .environment(\.layoutDirection, .rightToLeft)
}
