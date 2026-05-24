import SwiftUI

// MARK: - AdminStaffList
//
// Full paginated staff list with role filter (All / Teachers / Staff).
// Uses the same `AdminViewModel` as the dashboard — `staffFilter` triggers
// a refetch via the model's didSet.

struct AdminStaffList: View {
    @Bindable var viewModel: AdminViewModel

    var body: some View {
        List {
            Section {
                Picker("admin.staff.filter.title", selection: $viewModel.staffFilter) {
                    ForEach(AdminStaffFilter.allCases, id: \.self) { filter in
                        Text(filter.label).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }

            Section {
                if viewModel.staff.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.square")
                            .font(.system(size: 36))
                            .foregroundStyle(.tertiary)
                        Text("admin.staff.empty")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(viewModel.staff) { member in
                        StaffDetailRow(member: member)
                    }
                }
            } header: {
                Text("admin.section.staff")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(Text("admin.section.staff"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct StaffDetailRow: View {
    let member: AdminStaffMember

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Color.accentColor.opacity(0.12)
                if let url = member.photoUrl, let parsed = URL(string: url) {
                    AsyncImage(url: parsed) { phase in
                        if case .success(let image) = phase {
                            image.resizable().scaledToFill()
                        } else {
                            Image(systemName: "person.fill")
                                .foregroundStyle(.tint)
                        }
                    }
                } else {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.tint)
                }
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(member.fullName).font(.body.weight(.medium))
                HStack(spacing: 6) {
                    if let dept = member.department, !dept.isEmpty {
                        Text(dept).font(.caption).foregroundStyle(.secondary)
                    }
                    if let position = member.position, !position.isEmpty {
                        Text(position).font(.caption).foregroundStyle(.secondary)
                    }
                    if let subject = member.subject, !subject.isEmpty {
                        Text(subject).font(.caption).foregroundStyle(.secondary)
                    }
                }
                if let id = member.employeeId, !id.isEmpty {
                    Text(id).font(.caption2.monospaced()).foregroundStyle(.tertiary)
                }
            }

            Spacer()

            Text(member.roleKind.label)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Capsule().fill(member.roleKind.color.opacity(0.15)))
                .foregroundStyle(member.roleKind.color)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}
