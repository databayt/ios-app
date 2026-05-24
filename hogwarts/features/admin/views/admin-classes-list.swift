import SwiftUI

// MARK: - AdminClassesList
//
// Full paginated classes list grouped by grade. Uses the dashboard view
// model so we don't refetch.

struct AdminClassesList: View {
    @Bindable var viewModel: AdminViewModel

    private var grouped: [(grade: String, classes: [AdminClass])] {
        let g = Dictionary(grouping: viewModel.classes) { $0.grade?.name ?? "—" }
        return g
            .map { ($0.key, $0.value.sorted { $0.name < $1.name }) }
            .sorted { $0.0 < $1.0 }
    }

    var body: some View {
        List {
            if viewModel.classes.isEmpty {
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "person.3")
                            .font(.system(size: 36))
                            .foregroundStyle(.tertiary)
                        Text("admin.classes.empty")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .listRowBackground(Color.clear)
                }
            } else {
                ForEach(grouped, id: \.grade) { (grade, classes) in
                    Section(grade) {
                        ForEach(classes) { cls in
                            ClassDetailRow(item: cls)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(Text("admin.section.classes"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ClassDetailRow: View {
    let item: AdminClass

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name).font(.body.weight(.medium))
                HStack(spacing: 6) {
                    if let teacher = item.homeroomTeacher {
                        Label(teacher.name, systemImage: "person.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if let room = item.classroom {
                        Label(room.name, systemImage: "door.right.hand.open")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(item.studentCount)")
                    .font(.title3.weight(.heavy))
                    .monospacedDigit()
                if let max = item.maxCapacity, max > 0 {
                    Text("/ \(max)")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .monospacedDigit()
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}
