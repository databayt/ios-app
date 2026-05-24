import SwiftUI

// MARK: - ExamAttemptView
//
// Full attempt flow:
//   1. Loading → shows progress while we start the session
//   2. Taking → big question card + answer area + nav strip + timer pill
//   3. Submitting → blocking spinner while POST /answers runs
//   4. Submitted → success screen with auto-graded count
//   5. Error → retry button
//
// The timer is in the view model (one Task.sleep loop). Auto-submits at 0.

struct ExamAttemptView: View {
    let examId: String
    let examTitle: String

    @State private var viewModel: ExamAttemptViewModel
    @State private var showSubmitConfirmation = false
    @Environment(\.dismiss) private var dismiss

    init(examId: String, examTitle: String) {
        self.examId = examId
        self.examTitle = examTitle
        _viewModel = State(wrappedValue: ExamAttemptViewModel(examId: examId))
    }

    var body: some View {
        Group {
            switch viewModel.phase {
            case .loading:
                loading
            case .taking:
                taking
            case .submitting:
                submitting
            case .submitted(let response):
                submittedView(response: response)
            case .error(let message):
                errorState(message)
            }
        }
        .navigationTitle(Text(examTitle))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if case .taking = viewModel.phase {
                    Text(viewModel.timeRemainingFormatted)
                        .font(.subheadline.monospacedDigit().weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(viewModel.timeRemainingColor.opacity(0.18)))
                        .foregroundStyle(viewModel.timeRemainingColor)
                        .accessibilityLabel(Text("examAttempt.timer.a11y \(viewModel.timeRemainingFormatted)"))
                }
            }
        }
        .task { await viewModel.start() }
        .confirmationDialog(
            String(localized: "examAttempt.submit.confirmTitle"),
            isPresented: $showSubmitConfirmation,
            titleVisibility: .visible
        ) {
            Button(String(localized: "examAttempt.submit.confirm"), role: .destructive) {
                Task { await viewModel.submit() }
            }
            Button(String(localized: "common.cancel"), role: .cancel) { }
        } message: {
            Text("examAttempt.submit.message \(viewModel.answeredCount) \(viewModel.totalCount)")
        }
    }

    // MARK: - Phase views

    private var loading: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("examAttempt.loading")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var taking: some View {
        if let question = viewModel.currentQuestion {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        progressHeader
                        questionCard(question)
                        answerArea(for: question)
                    }
                    .padding(16)
                }

                navStrip
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        } else {
            Text("examAttempt.noQuestions")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var submitting: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("examAttempt.submitting")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func submittedView(response: ExamSubmissionResponse) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)
            Text("examAttempt.submitted.title")
                .font(.title2.weight(.bold))
            Text("examAttempt.submitted.body \(response.answeredCount) \(response.totalQuestions)")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)
            if let auto = response.autoGradedScore {
                Text("examAttempt.submitted.autoGraded \(auto)")
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.accentGreen.opacity(0.15)))
                    .foregroundStyle(.green)
            }
            Button(String(localized: "common.done")) { dismiss() }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private func errorState(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundStyle(.orange)
            Text("examAttempt.error.title").font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button(String(localized: "common.retry")) {
                Task { await viewModel.start() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Subviews

    private var progressHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("examAttempt.questionCount \(viewModel.currentIndex + 1) \(viewModel.totalCount)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("examAttempt.answeredCount \(viewModel.answeredCount) \(viewModel.totalCount)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            ProgressView(
                value: Double(viewModel.currentIndex + 1),
                total: Double(max(1, viewModel.totalCount))
            )
            .tint(.accentColor)
        }
    }

    private func questionCard(_ q: ExamQuestion) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("examAttempt.marks \(q.marks)")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color.accentBlue.opacity(0.15)))
                    .foregroundStyle(Color.accentBlue)
                Spacer()
            }
            Text(q.text)
                .font(.body)
                .accessibilityAddTraits(.isHeader)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    @ViewBuilder
    private func answerArea(for q: ExamQuestion) -> some View {
        switch q.typeKind {
        case .multipleChoice:
            mcqOptions(for: q)
        case .trueFalse:
            trueFalseOptions(for: q)
        case .shortAnswer, .essay:
            textArea(for: q)
        case .unknown:
            textArea(for: q)
        }
    }

    private func mcqOptions(for q: ExamQuestion) -> some View {
        let options = q.optionsList
        return VStack(spacing: 8) {
            ForEach(options) { option in
                optionButton(question: q, key: option.key, label: option.text)
            }
            if options.isEmpty {
                Text("examAttempt.noOptions")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func trueFalseOptions(for q: ExamQuestion) -> some View {
        VStack(spacing: 8) {
            optionButton(question: q, key: "TRUE",  label: String(localized: "common.true"))
            optionButton(question: q, key: "FALSE", label: String(localized: "common.false"))
        }
    }

    private func optionButton(question: ExamQuestion, key: String, label: String) -> some View {
        let binding = viewModel.answer(for: question.id)
        let isSelected = binding.wrappedValue == key
        return Button {
            binding.wrappedValue = key
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .strokeBorder(isSelected ? Color.accentColor : Color(uiColor: .tertiarySystemFill),
                                      lineWidth: isSelected ? 6 : 1.5)
                    if isSelected {
                        Circle().fill(.white).padding(8)
                    }
                }
                .frame(width: 22, height: 22)
                Text(label)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? Color.accentColor.opacity(0.10) : Color(uiColor: .secondarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(isSelected ? Color.accentColor : .clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func textArea(for q: ExamQuestion) -> some View {
        let binding = viewModel.answer(for: q.id)
        return VStack(alignment: .leading, spacing: 6) {
            Text("examAttempt.yourAnswer")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            TextEditor(text: binding)
                .frame(minHeight: 140)
                .padding(8)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .accessibilityLabel(Text("examAttempt.yourAnswer"))
        }
    }

    private var navStrip: some View {
        HStack(spacing: 10) {
            Button {
                viewModel.goPrevious()
            } label: {
                Label(String(localized: "examAttempt.previous"), systemImage: "chevron.left")
                    .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.currentIndex == 0)

            Spacer(minLength: 0)

            if viewModel.currentIndex == viewModel.totalCount - 1 {
                Button {
                    showSubmitConfirmation = true
                } label: {
                    Label(String(localized: "examAttempt.submitButton"), systemImage: "paperplane.fill")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.canSubmit)
            } else {
                Button {
                    viewModel.goNext()
                } label: {
                    Label(String(localized: "examAttempt.next"), systemImage: "chevron.right")
                        .labelStyle(.titleAndIcon)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.bar)
    }
}
