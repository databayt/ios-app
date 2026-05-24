import SwiftUI

struct LessonPlanFormView: View {
    @State private var viewModel: LessonPlanFormViewModel
    let tenantContext: TenantContext
    @Environment(\.dismiss) private var dismiss

    init(plan: LessonPlan, tenantContext: TenantContext) {
        _viewModel = State(initialValue: LessonPlanFormViewModel(plan: plan))
        self.tenantContext = tenantContext
    }

    var body: some View {
        Form {
            Section("lessons.section.overview") {
                TextField("lessons.subject", text: $viewModel.plan.subjectName)
                TextField("lessons.topic", text: $viewModel.plan.topic)
                TextField("lessons.date", text: $viewModel.plan.date)
            }

            Section("lessons.section.objectives") {
                ForEach($viewModel.plan.objectives, id: \.self) { $obj in
                    TextField("lessons.objective", text: $obj)
                }
                Button("lessons.add_objective", action: viewModel.addObjective)
            }

            Section("lessons.section.activities") {
                ForEach($viewModel.plan.activities) { $act in
                    VStack(alignment: .leading, spacing: 6) {
                        TextField("lessons.activity_description", text: $act.description, axis: .vertical)
                        HStack {
                            Picker("lessons.activity_type", selection: $act.type) {
                                ForEach(ActivityType.allCases) { Text($0.displayName).tag($0) }
                            }
                            Stepper("\(act.duration) min", value: $act.duration, in: 1...180, step: 5)
                        }
                    }
                }
                Button("lessons.add_activity", action: viewModel.addActivity)
            }

            Section("lessons.section.homework") {
                TextField("lessons.homework", text: Binding(
                    get: { viewModel.plan.homework ?? "" },
                    set: { viewModel.plan.homework = $0.isEmpty ? nil : $0 }
                ), axis: .vertical)
            }

            Section("lessons.section.notes") {
                TextField("lessons.teacher_notes", text: Binding(
                    get: { viewModel.plan.teacherNotes ?? "" },
                    set: { viewModel.plan.teacherNotes = $0.isEmpty ? nil : $0 }
                ), axis: .vertical)
            }
        }
        .navigationTitle("lessons.edit")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("save") {
                    Task { await viewModel.save(); dismiss() }
                }
                .disabled(viewModel.isSaving)
            }
        }
        .task { viewModel.tenantContext = tenantContext }
    }
}
