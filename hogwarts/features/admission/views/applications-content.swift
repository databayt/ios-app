import SwiftUI

struct ApplicationsContent: View {
    @State private var viewModel = ApplicationsViewModel()
    @State private var selectedApplication: AdmissionApplication?
    @State private var newApplication: AdmissionApplication?

    let tenantContext: TenantContext

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.applications.isEmpty {
                    ProgressView()
                } else if viewModel.applications.isEmpty {
                    ContentUnavailableView(
                        "admission.empty.title",
                        systemImage: "doc.text",
                        description: Text("admission.empty.subtitle")
                    )
                } else {
                    List(viewModel.applications) { app in
                        Button {
                            selectedApplication = app
                        } label: {
                            ApplicationRow(application: app)
                        }
                        .buttonStyle(.plain)
                    }
                    .refreshable { await viewModel.refresh() }
                }
            }
            .navigationTitle("admission.title")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { newApplication = await viewModel.createNew() }
                    } label: {
                        Label("admission.new", systemImage: "plus")
                    }
                }
            }
            .navigationDestination(item: $selectedApplication) { app in
                ApplicationStatusView(applicationId: app.id, tenantContext: tenantContext)
            }
            .navigationDestination(item: $newApplication) { app in
                ApplicationFormView(application: app, tenantContext: tenantContext)
            }
            .alert("error.title", isPresented: .constant(viewModel.error != nil), presenting: viewModel.error) { _ in
                Button("ok") { viewModel.error = nil }
            } message: { Text($0) }
            .task {
                viewModel.tenantContext = tenantContext
                await viewModel.load()
            }
        }
    }
}

private struct ApplicationRow: View {
    let application: AdmissionApplication

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(application.personalInfo.givenNameEn) \(application.personalInfo.familyNameEn)")
                    .font(.headline)
                Spacer()
                StatusBadge(status: application.status)
            }
            if let tracking = application.trackingNumber {
                Text("admission.tracking \(tracking)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text("admission.step \(application.currentStep.rawValue) \(ApplicationStep.allCases.count) \(application.currentStep.title)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct StatusBadge: View {
    let status: ApplicationStatus

    var body: some View {
        Text(status.displayName)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private var color: Color {
        switch status {
        case .draft: .gray
        case .submitted, .underReview, .interviewScheduled: .blue
        case .accepted: .green
        case .rejected: .red
        case .waitlisted: .orange
        }
    }
}
