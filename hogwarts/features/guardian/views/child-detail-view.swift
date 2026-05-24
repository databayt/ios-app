import SwiftUI

// MARK: - ChildDetailView
//
// Hero (photo + name + grade · section) + four-tile shortcut grid that
// jumps into the existing Fees / Report Cards / etc. screens scoped to the
// child via `studentId` parameter. Plus a metadata section with admission
// info, contact details, and status.

struct ChildDetailView: View {
    let id: String

    @State private var viewModel = ChildDetailViewModel()
    @Environment(\.locale) private var locale

    var body: some View {
        Group {
            if let detail = viewModel.detail {
                content(for: detail)
            } else if let error = viewModel.lastError {
                errorState(error)
            } else {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(Text(viewModel.detail?.fullName ?? String(localized: "guardian.child.title")))
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load(childId: id) }
        .refreshable { await viewModel.load(childId: id) }
    }

    private func content(for d: ChildDetail) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                hero(for: d)
                shortcutsGrid
                infoCard(for: d)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
    }

    private func hero(for d: ChildDetail) -> some View {
        VStack(spacing: 12) {
            avatar(for: d)
                .frame(width: 96, height: 96)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(.white.opacity(0.18), lineWidth: 1))
                .shadow(color: .black.opacity(0.10), radius: 8, y: 4)
            Text(d.fullName)
                .font(.title3.weight(.bold))
                .accessibilityAddTraits(.isHeader)
            if let section = d.section {
                Label(
                    section.grade.map { "\($0) · \(section.name)" } ?? section.name,
                    systemImage: "book.closed"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private func avatar(for d: ChildDetail) -> some View {
        if let url = d.photoUrl, let parsed = URL(string: url) {
            AsyncImage(url: parsed) { phase in
                switch phase {
                case .success(let image): image.resizable().scaledToFill()
                default: placeholder
                }
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        ZStack {
            LinearGradient(
                colors: [.accentBlue.opacity(0.6), .accentPurple.opacity(0.4)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundStyle(.white.opacity(0.85))
        }
    }

    private var shortcutsGrid: some View {
        let columns = [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10),
        ]
        return LazyVGrid(columns: columns, spacing: 10) {
            shortcut(label: "guardian.shortcut.attendance",
                     systemImage: "checkmark.circle.fill",
                     tint: .accentGreen,
                     route: .childAttendance(id: id))
            shortcut(label: "guardian.shortcut.grades",
                     systemImage: "chart.bar.fill",
                     tint: .accentOrange,
                     route: .childGrades(id: id))
            shortcut(label: "guardian.shortcut.fees",
                     systemImage: "dollarsign.circle.fill",
                     tint: .accentBlue,
                     route: .childFees(id: id))
            shortcut(label: "guardian.shortcut.timetable",
                     systemImage: "calendar",
                     tint: .accentPurple,
                     route: .childTimetable(id: id))
        }
    }

    private func shortcut(label: LocalizedStringResource, systemImage: String, tint: Color, route: GuardianRoute) -> some View {
        NavigationLink(value: route) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.title3)
                    .foregroundStyle(tint)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(tint.opacity(0.15)))
                Text(label)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "chevron.forward")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(12)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func infoCard(for d: ChildDetail) -> some View {
        VStack(spacing: 0) {
            row(label: "guardian.info.admissionNumber",
                value: d.admissionNumber ?? d.studentId ?? d.grNumber ?? "—")
            divider
            if let dob = d.dateOfBirth {
                row(label: "guardian.info.dateOfBirth",
                    value: dob.formatted(date: .abbreviated, time: .omitted))
                divider
            }
            if let gender = d.gender, !gender.isEmpty {
                row(label: "guardian.info.gender", value: gender.capitalized)
                divider
            }
            if let blood = d.bloodGroup, !blood.isEmpty {
                row(label: "guardian.info.bloodGroup", value: blood)
                divider
            }
            if let nat = d.nationality, !nat.isEmpty {
                row(label: "guardian.info.nationality", value: nat)
                divider
            }
            if let phone = d.phone, !phone.isEmpty {
                row(label: "guardian.info.phone", value: phone)
                divider
            }
            if let email = d.email, !email.isEmpty {
                row(label: "guardian.info.email", value: email)
                divider
            }
            if let enrolled = d.enrollmentDate {
                row(label: "guardian.info.enrollmentDate",
                    value: enrolled.formatted(date: .abbreviated, time: .omitted))
            }
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func row(label: LocalizedStringResource, value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary)
            Spacer(minLength: 12)
            Text(value).multilineTextAlignment(.trailing)
        }
        .font(.callout)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    private var divider: some View { Divider().padding(.leading, 14) }

    private func errorState(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 44))
                .foregroundStyle(.orange)
            Text("guardian.child.loadFailed").font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button(String(localized: "guardian.retry")) {
                Task { await viewModel.load(childId: id) }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
