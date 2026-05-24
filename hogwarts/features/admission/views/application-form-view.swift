import SwiftUI

struct ApplicationFormView: View {
    @State private var viewModel: ApplicationFormViewModel
    let tenantContext: TenantContext

    init(application: AdmissionApplication, tenantContext: TenantContext) {
        _viewModel = State(initialValue: ApplicationFormViewModel(application: application))
        self.tenantContext = tenantContext
    }

    var body: some View {
        Form {
            switch viewModel.currentStep {
            case .personalInfo:    personalInfoSection
            case .contactInfo:     contactInfoSection
            case .guardianInfo:    guardianInfoSection
            case .academicHistory: academicHistorySection
            case .documents:       documentsSection
            case .review:          reviewSection
            }
        }
        .navigationTitle(viewModel.currentStep.title)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .top) {
            ProgressView(value: viewModel.progress)
                .padding(.horizontal)
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                if viewModel.currentStep.rawValue > 1 {
                    Button("admission.previous") { viewModel.goToPrevious() }
                }
                Spacer()
                if viewModel.currentStep == .review {
                    Button("admission.submit") {
                        Task { await viewModel.submit() }
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button("admission.next") {
                        Task {
                            await viewModel.save()
                            viewModel.goToNext()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .background(.bar)
        }
        .task { viewModel.tenantContext = tenantContext }
    }

    private var personalInfoSection: some View {
        Section {
            TextField("admission.given_name_en", text: $viewModel.application.personalInfo.givenNameEn)
            TextField("admission.family_name_en", text: $viewModel.application.personalInfo.familyNameEn)
            TextField("admission.given_name_ar", text: $viewModel.application.personalInfo.givenNameAr)
            TextField("admission.family_name_ar", text: $viewModel.application.personalInfo.familyNameAr)
            TextField("admission.date_of_birth", text: $viewModel.application.personalInfo.dateOfBirth)
            TextField("admission.nationality", text: $viewModel.application.personalInfo.nationality)
            TextField("admission.national_id", text: $viewModel.application.personalInfo.nationalId)
        }
    }

    private var contactInfoSection: some View {
        Section {
            TextField("admission.address", text: $viewModel.application.contactInfo.address)
            TextField("admission.city", text: $viewModel.application.contactInfo.city)
            TextField("admission.phone", text: $viewModel.application.contactInfo.phone)
            TextField("admission.email", text: $viewModel.application.contactInfo.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
        }
    }

    private var guardianInfoSection: some View {
        Section {
            ForEach($viewModel.application.guardians) { $guardian in
                VStack(alignment: .leading) {
                    TextField("admission.guardian_name", text: $guardian.name)
                    TextField("admission.guardian_relationship", text: $guardian.relationship)
                    TextField("admission.guardian_phone", text: $guardian.phone)
                }
            }
            Button("admission.add_guardian") {
                viewModel.application.guardians.append(GuardianInfo())
            }
        }
    }

    private var academicHistorySection: some View {
        Section {
            TextField("admission.previous_school", text: $viewModel.application.academicHistory.previousSchool)
            TextField("admission.last_grade", text: $viewModel.application.academicHistory.lastGrade)
            TextField("admission.applying_grade", text: $viewModel.application.academicHistory.applyingGrade)
            Toggle("admission.special_needs", isOn: $viewModel.application.academicHistory.hasSpecialNeeds)
            if viewModel.application.academicHistory.hasSpecialNeeds {
                TextField("admission.special_needs_details", text: $viewModel.application.academicHistory.specialNeedsDetails, axis: .vertical)
            }
        }
    }

    private var documentsSection: some View {
        Section("admission.section.documents") {
            ForEach(viewModel.application.documents) { doc in
                HStack {
                    Image(systemName: "doc")
                    Text(doc.name)
                    Spacer()
                    Text(doc.type).foregroundStyle(.secondary).font(.caption)
                }
            }
            Button("admission.upload_document") {
                // Document picker TBD; wire to file importer in follow-up
            }
        }
    }

    private var reviewSection: some View {
        Section("admission.section.review") {
            Text("\(viewModel.application.personalInfo.givenNameEn) \(viewModel.application.personalInfo.familyNameEn)")
            Text(viewModel.application.contactInfo.email).foregroundStyle(.secondary)
            Text("admission.review.guardians_count \(viewModel.application.guardians.count)")
            Text("admission.review.documents_count \(viewModel.application.documents.count)")
        }
    }
}
