import SwiftUI

struct QuizSessionView: View {
    @State private var viewModel = QuizSessionViewModel()
    let mode: QuizMode
    let tenantContext: TenantContext

    var body: some View {
        Group {
            if let result = viewModel.result {
                ResultView(result: result)
            } else if let session = viewModel.session, let question = session.currentQuestion {
                VStack(spacing: 16) {
                    ProgressView(value: session.progress).padding(.horizontal)
                    HStack {
                        Label("\(session.score) pts", systemImage: "bolt.fill")
                        Spacer()
                        if session.streakCount > 1 {
                            Label("\(session.streakCount)x", systemImage: "flame.fill").foregroundStyle(.orange)
                        }
                    }
                    .font(.caption)
                    .padding(.horizontal)

                    Text(question.text)
                        .font(.title3.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .padding()

                    VStack(spacing: 10) {
                        ForEach(question.options, id: \.self) { opt in
                            Button {
                                viewModel.selectedAnswer = opt
                            } label: {
                                HStack {
                                    Text(opt)
                                    Spacer()
                                    if viewModel.selectedAnswer == opt {
                                        Image(systemName: "checkmark.circle.fill").foregroundStyle(.tint)
                                    }
                                }
                                .padding()
                                .background(.thinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    Button {
                        Task {
                            if viewModel.showFeedback {
                                viewModel.next()
                            } else {
                                await viewModel.submit()
                            }
                        }
                    } label: {
                        Text(viewModel.showFeedback ? "quizgame.next" : "quizgame.submit")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.selectedAnswer == nil)
                    .padding()
                }
            } else if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationTitle(mode.rawValue.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.tenantContext = tenantContext
            await viewModel.start(mode: mode, subject: nil, difficulty: nil)
        }
    }
}

private struct ResultView: View {
    let result: QuizResult
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "rosette").font(.system(size: 60)).foregroundStyle(.yellow)
            Text("quizgame.result.title").font(.title2.weight(.bold))
            HStack(spacing: 24) {
                Stat(value: "\(result.correctAnswers)/\(result.totalQuestions)", label: "quizgame.correct")
                Stat(value: "\(Int(result.accuracy * 100))%", label: "quizgame.accuracy")
                Stat(value: "+\(result.xpEarned)", label: "quizgame.xp")
            }
            if !result.newAchievements.isEmpty {
                Text("quizgame.new_achievements").font(.headline)
                ForEach(result.newAchievements) { a in
                    Label(a.name, systemImage: "star.fill").foregroundStyle(.yellow)
                }
            }
            Spacer()
        }
        .padding()
    }
}

private struct Stat: View {
    let value: String
    let label: LocalizedStringKey
    var body: some View {
        VStack {
            Text(value).font(.title3.weight(.bold))
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
    }
}
