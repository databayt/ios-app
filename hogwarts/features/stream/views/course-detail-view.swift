import SwiftUI

struct CourseDetailView: View {
    @State private var viewModel = CourseDetailViewModel()
    let courseId: String
    let tenantContext: TenantContext

    var body: some View {
        Group {
            if let course = viewModel.course {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if let url = course.thumbnailUrl, let u = URL(string: url) {
                            AsyncImage(url: u) { img in img.resizable() } placeholder: { Color.gray.opacity(0.2) }
                                .aspectRatio(16/9, contentMode: .fill)
                                .frame(maxWidth: .infinity)
                                .clipped()
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text(course.title).font(.title2.weight(.bold))
                            Text(course.instructorName).foregroundStyle(.secondary)
                            HStack {
                                Label("\(course.lessonCount) lessons", systemImage: "play.square.stack")
                                Spacer()
                                Label(course.totalDuration, systemImage: "clock")
                                Spacer()
                                Label("\(course.enrollmentCount)", systemImage: "person.3")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            Divider()
                            Text(course.description)

                            if !viewModel.chapters.isEmpty {
                                Text("stream.chapters").font(.headline)
                                ForEach(viewModel.chapters) { chapter in
                                    NavigationLink {
                                        ChapterDetailView(chapter: chapter, tenantContext: tenantContext)
                                    } label: {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(chapter.title).foregroundStyle(.primary)
                                                Text("\(chapter.completedLessons)/\(chapter.lessonCount)").font(.caption).foregroundStyle(.secondary)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right").foregroundStyle(.secondary)
                                        }
                                        .padding(.vertical, 6)
                                    }
                                    .buttonStyle(.plain)
                                    Divider()
                                }
                            }
                        }
                        .padding()
                    }
                }
            } else if viewModel.isLoading {
                ProgressView()
            }
        }
        .safeAreaInset(edge: .bottom) {
            if viewModel.enrollment == nil, viewModel.course != nil {
                Button {
                    Task { await viewModel.enroll() }
                } label: {
                    if viewModel.isEnrolling { ProgressView() } else { Text("stream.enroll") }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.bar)
            }
        }
        .navigationTitle("stream.course")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.tenantContext = tenantContext
            await viewModel.load(id: courseId)
        }
    }
}

struct ChapterDetailView: View {
    let chapter: Chapter
    let tenantContext: TenantContext

    var body: some View {
        List(chapter.lessons ?? []) { lesson in
            NavigationLink {
                LessonPlayerView(lessonId: lesson.id, tenantContext: tenantContext)
            } label: {
                HStack {
                    Image(systemName: iconFor(lesson.type)).foregroundStyle(.tint).frame(width: 28)
                    VStack(alignment: .leading) {
                        Text(lesson.title)
                        Text(lesson.duration).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    if lesson.isCompleted { Image(systemName: "checkmark.circle.fill").foregroundStyle(.green) }
                    if lesson.isLocked { Image(systemName: "lock.fill").foregroundStyle(.secondary) }
                }
            }
            .disabled(lesson.isLocked)
        }
        .navigationTitle(chapter.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func iconFor(_ type: LessonType) -> String {
        switch type {
        case .video: "play.rectangle"
        case .text:  "doc.text"
        case .quiz:  "questionmark.circle"
        }
    }
}
