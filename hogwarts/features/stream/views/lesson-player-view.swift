import SwiftUI
import AVKit

struct LessonPlayerView: View {
    @State private var viewModel = LessonViewModel()
    let lessonId: String
    let tenantContext: TenantContext

    var body: some View {
        Group {
            if let lesson = viewModel.lesson {
                switch lesson.type {
                case .video: VideoLessonView(lesson: lesson, onComplete: { Task { await viewModel.markComplete() } })
                case .text:  TextLessonView(lesson: lesson, onComplete: { Task { await viewModel.markComplete() } })
                case .quiz:  QuizLessonView(viewModel: viewModel)
                }
            } else if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationTitle("stream.lesson")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.tenantContext = tenantContext
            await viewModel.load(id: lessonId)
        }
    }
}

private struct VideoLessonView: View {
    let lesson: StreamLesson
    let onComplete: () -> Void

    var body: some View {
        VStack {
            if let urlStr = lesson.contentUrl, let url = URL(string: urlStr) {
                VideoPlayer(player: AVPlayer(url: url))
                    .aspectRatio(16/9, contentMode: .fit)
            } else {
                Rectangle().fill(.black).aspectRatio(16/9, contentMode: .fit)
                    .overlay(Text("stream.video.unavailable").foregroundStyle(.white))
            }
            Text(lesson.title).font(.headline).padding()
            Spacer()
            Button("stream.mark_complete", action: onComplete)
                .buttonStyle(.borderedProminent)
                .padding()
        }
    }
}

private struct TextLessonView: View {
    let lesson: StreamLesson
    let onComplete: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(lesson.title).font(.title2.weight(.bold))
                Text(lesson.contentUrl ?? "stream.text.empty")
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            Button("stream.mark_complete", action: onComplete)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.bar)
        }
    }
}

private struct QuizLessonView: View {
    @Bindable var viewModel: LessonViewModel

    var body: some View {
        Group {
            if viewModel.didComplete {
                ContentUnavailableView("stream.quiz.complete", systemImage: "checkmark.seal.fill", description: Text("stream.quiz.complete_subtitle"))
            } else {
                Form {
                    ForEach(Array(viewModel.quiz.enumerated()), id: \.element.id) { idx, q in
                        Section(q.question) {
                            ForEach(Array(q.options.enumerated()), id: \.offset) { optIdx, opt in
                                Button {
                                    viewModel.quizAnswers[idx] = optIdx
                                } label: {
                                    HStack {
                                        Image(systemName: viewModel.quizAnswers[idx] == optIdx ? "largecircle.fill.circle" : "circle")
                                        Text(opt).foregroundStyle(.primary)
                                    }
                                }
                            }
                        }
                    }
                    Section {
                        Button("stream.quiz.submit") {
                            Task { await viewModel.submitQuiz() }
                        }
                        .disabled(viewModel.quizAnswers.contains(nil))
                    }
                }
            }
        }
    }
}
