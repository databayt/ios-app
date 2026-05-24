import SwiftUI

struct LessonDetailView: View {
    @State private var viewModel = LessonDetailViewModel()
    let planId: String
    let tenantContext: TenantContext

    var body: some View {
        Group {
            if let plan = viewModel.plan {
                List {
                    Section("lessons.section.overview") {
                        labeled("lessons.subject", plan.subjectName)
                        labeled("lessons.topic", plan.topic)
                        labeled("lessons.date", plan.date)
                        HStack { Text("lessons.status"); Spacer(); StatusPill(status: plan.status) }
                    }
                    if !plan.objectives.isEmpty {
                        Section("lessons.section.objectives") {
                            ForEach(plan.objectives, id: \.self) { Text("• \($0)") }
                        }
                    }
                    if !plan.activities.isEmpty {
                        Section("lessons.section.activities") {
                            ForEach(plan.activities) { act in
                                HStack {
                                    Image(systemName: act.type.icon)
                                    VStack(alignment: .leading) {
                                        Text(act.description)
                                        Text("\(act.duration) min").font(.caption).foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    if !plan.resources.isEmpty {
                        Section("lessons.section.resources") {
                            ForEach(plan.resources) { res in
                                HStack {
                                    Image(systemName: res.type.icon)
                                    Text(res.name)
                                    Spacer()
                                    if let url = URL(string: res.url) { Link(destination: url) { Image(systemName: "arrow.up.right.square") } }
                                }
                            }
                        }
                    }
                    if let hw = plan.homework, !hw.isEmpty {
                        Section("lessons.section.homework") { Text(hw) }
                    }
                    if let notes = plan.teacherNotes, !notes.isEmpty {
                        Section("lessons.section.notes") { Text(notes) }
                    }
                }
            } else if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationTitle("lessons.lesson")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.tenantContext = tenantContext
            await viewModel.load(id: planId)
        }
    }

    private func labeled(_ keyLabel: LocalizedStringKey, _ value: String) -> some View {
        HStack { Text(keyLabel); Spacer(); Text(value).foregroundStyle(.secondary) }
    }
}
