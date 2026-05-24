import SwiftUI

struct CurriculumMapView: View {
    @State private var viewModel = CurriculumMapViewModel()
    let termId: String
    let tenantContext: TenantContext

    var body: some View {
        Group {
            if let map = viewModel.map {
                List {
                    Section { Text(map.termName).font(.title3.weight(.semibold)) }
                    ForEach(map.subjects) { subject in
                        Section(subject.subjectName) {
                            ForEach(subject.topics) { topic in
                                HStack {
                                    Text("W\(topic.weekNumber)")
                                        .font(.caption2.weight(.bold))
                                        .frame(width: 30)
                                        .foregroundStyle(.secondary)
                                    Text(topic.title)
                                    Spacer()
                                    Circle()
                                        .fill(statusColor(topic.status))
                                        .frame(width: 10, height: 10)
                                }
                            }
                        }
                    }
                }
            } else if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationTitle("lessons.curriculum")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.tenantContext = tenantContext
            viewModel.termId = termId
            await viewModel.load()
        }
    }

    private func statusColor(_ status: TopicStatus) -> Color {
        switch status {
        case .notStarted: .gray
        case .inProgress: .blue
        case .completed: .green
        }
    }
}
