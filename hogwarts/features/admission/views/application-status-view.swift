import SwiftUI

struct ApplicationStatusView: View {
    @State private var viewModel = ApplicationStatusViewModel()
    let applicationId: String
    let tenantContext: TenantContext

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let app = viewModel.application {
                List {
                    Section {
                        HStack {
                            Text("admission.status")
                            Spacer()
                            Text(app.status.displayName)
                                .foregroundStyle(.secondary)
                        }
                        if let tracking = app.trackingNumber {
                            HStack {
                                Text("admission.tracking_number")
                                Spacer()
                                Text(tracking).foregroundStyle(.secondary)
                            }
                        }
                        HStack {
                            Text("admission.current_step")
                            Spacer()
                            Text(app.currentStep.title).foregroundStyle(.secondary)
                        }
                    }
                    Section("admission.applicant") {
                        Text("\(app.personalInfo.givenNameEn) \(app.personalInfo.familyNameEn)")
                        if !app.personalInfo.nationalId.isEmpty {
                            Text(app.personalInfo.nationalId).foregroundStyle(.secondary)
                        }
                    }
                    Section("admission.contact") {
                        Text(app.contactInfo.email).foregroundStyle(.secondary)
                        Text(app.contactInfo.phone).foregroundStyle(.secondary)
                    }
                }
            } else if let error = viewModel.error {
                ContentUnavailableView("error.title", systemImage: "exclamationmark.triangle", description: Text(error))
            }
        }
        .navigationTitle("admission.application")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.tenantContext = tenantContext
            await viewModel.load(id: applicationId)
        }
    }
}
