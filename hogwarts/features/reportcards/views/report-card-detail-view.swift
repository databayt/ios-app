import SwiftUI
import SafariServices

// MARK: - ReportCardDetailView
//
// Header with student + term + overall grade, attendance summary, full
// per-subject grade table, teacher / principal comments, "View PDF" link
// (opens in SafariView). Mirrors web `/report-cards/[id]`.

struct ReportCardDetailView: View {
    let id: String

    @State private var detail: ReportCardDetail?
    @State private var lastError: String?
    @State private var pdfURL: PDFLink?
    @Environment(\.locale) private var locale

    private let actions = ReportCardsActions()

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
        .navigationTitle(Text(detail?.termName ?? String(localized: "reportCards.detail.title")))
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
        .refreshable { await load() }
        .sheet(item: $pdfURL) { link in
            SafariView(url: link.url)
                .ignoresSafeArea()
        }
    }

    // MARK: - Content

    private func content(for d: ReportCardDetail) -> some View {
        List {
            Section { headerCard(for: d).listRowSeparator(.hidden) }

            attendanceSection(for: d)

            if let grades = d.grades, !grades.isEmpty {
                Section(String(localized: "reportCards.detail.section.grades")) {
                    ForEach(grades) { row in
                        GradeRow(row: row)
                    }
                }
            }

            if let teacherComments = d.teacherComments, !teacherComments.isEmpty {
                Section(String(localized: "reportCards.detail.section.teacherComments")) {
                    Text(teacherComments)
                }
            }

            if let principalComments = d.principalComments, !principalComments.isEmpty {
                Section(String(localized: "reportCards.detail.section.principalComments")) {
                    Text(principalComments)
                }
            }

            if let urlString = d.pdfUrl, let url = URL(string: urlString) {
                Section {
                    Button {
                        pdfURL = PDFLink(url: url)
                    } label: {
                        Label(String(localized: "reportCards.detail.viewPDF"),
                              systemImage: "doc.fill")
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private func headerCard(for d: ReportCardDetail) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(d.student.fullName)
                .font(.title3.weight(.bold))
                .accessibilityAddTraits(.isHeader)
            HStack(spacing: 10) {
                if let grade = d.student.grade, !grade.isEmpty {
                    Label(grade, systemImage: "graduationcap")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if let section = d.student.section, !section.isEmpty {
                    Label(section, systemImage: "person.3")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 12) {
                gradeChip(for: d)
                if let gpa = d.overallGpa {
                    statPill(label: "reportCards.stat.gpa",
                             value: String(format: "%.2f", gpa),
                             tint: ReportCardGrade.color(for: d.overallGrade))
                }
                if let rank = d.rank {
                    statPill(label: "reportCards.stat.rank",
                             value: d.totalStudents.map { "\(rank) / \($0)" } ?? "\(rank)",
                             tint: .accentBlue)
                }
            }
        }
        .padding(.vertical, 6)
    }

    @ViewBuilder
    private func gradeChip(for d: ReportCardDetail) -> some View {
        if let g = d.overallGrade, !g.isEmpty {
            Text(g)
                .font(.title2.weight(.heavy))
                .frame(width: 56, height: 56)
                .background(Circle().fill(ReportCardGrade.color(for: g).opacity(0.18)))
                .foregroundStyle(ReportCardGrade.color(for: g))
                .accessibilityLabel(Text("reportCards.grade.a11y \(g)"))
        }
    }

    private func statPill(label: LocalizedStringResource, value: String, tint: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.subheadline.weight(.bold))
                .monospacedDigit()
                .foregroundStyle(tint)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Capsule().fill(tint.opacity(0.10)))
    }

    private func attendanceSection(for d: ReportCardDetail) -> some View {
        Section(String(localized: "reportCards.detail.section.attendance")) {
            if let p = d.daysPresent {
                LabeledContent(String(localized: "reportCards.attendance.present"),
                               value: "\(p)")
            }
            if let a = d.daysAbsent {
                LabeledContent(String(localized: "reportCards.attendance.absent"),
                               value: "\(a)")
            }
            if let l = d.daysLate {
                LabeledContent(String(localized: "reportCards.attendance.late"),
                               value: "\(l)")
            }
            if let rate = d.attendanceRate {
                LabeledContent(String(localized: "reportCards.attendance.rate"),
                               value: rate.formatted(.percent.precision(.fractionLength(0))))
            }
        }
    }

    // MARK: - Errors

    private func errorState(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundStyle(.orange)
            Text("reportCards.detail.loadFailed").font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button(String(localized: "reportCards.retry")) {
                Task { await load() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Loading

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

// MARK: - Grade row

private struct GradeRow: View {
    let row: ReportCardGradeRow

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(row.subject?.name ?? String(localized: "reportCards.subject.unknown"))
                    .font(.body.weight(.medium))
                if let comments = row.comments, !comments.isEmpty {
                    Text(comments)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            Spacer(minLength: 12)
            VStack(alignment: .trailing, spacing: 2) {
                if let g = row.grade, !g.isEmpty {
                    Text(g)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(row.color)
                }
                if let percentage = row.percentage {
                    Text(percentage.formatted(.percent.precision(.fractionLength(0))))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                } else if let score = row.score, let max = row.maxScore {
                    Text("\(formatted(score)) / \(formatted(max))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }

    private func formatted(_ value: Double) -> String {
        String(format: value.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f", value)
    }
}

// MARK: - PDF helpers

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

#Preview("LTR") { NavigationStack { ReportCardDetailView(id: "preview") } }
#Preview("RTL") {
    NavigationStack { ReportCardDetailView(id: "preview") }
        .environment(\.layoutDirection, .rightToLeft)
}
