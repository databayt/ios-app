import SwiftUI

struct LessonPlansContent: View {
    @State private var viewModel = LessonPlansViewModel()
    @State private var selected: LessonPlan?
    let tenantContext: TenantContext

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.plans.isEmpty {
                    ProgressView()
                } else if viewModel.plans.isEmpty {
                    ContentUnavailableView("lessons.empty.title", systemImage: "book.closed", description: Text("lessons.empty.subtitle"))
                } else {
                    List(viewModel.plans) { plan in
                        Button { selected = plan } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(plan.topic).font(.headline)
                                    Spacer()
                                    StatusPill(status: plan.status)
                                }
                                Text(plan.subjectName).font(.caption).foregroundStyle(.secondary)
                                Text(plan.date).font(.caption2).foregroundStyle(.tertiary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .refreshable { await viewModel.load() }
                }
            }
            .navigationTitle("lessons.title")
            .navigationDestination(item: $selected) { plan in
                LessonDetailView(planId: plan.id, tenantContext: tenantContext)
            }
            .task {
                viewModel.tenantContext = tenantContext
                await viewModel.load()
            }
        }
    }
}

struct StatusPill: View {
    let status: LessonPlanStatus
    var body: some View {
        Text(status.displayName)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
    private var color: Color {
        switch status {
        case .draft: .gray
        case .published: .blue
        case .completed: .green
        }
    }
}
