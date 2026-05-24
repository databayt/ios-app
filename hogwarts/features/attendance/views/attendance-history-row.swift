import SwiftUI

/// One row inside the student / guardian attendance history list.
/// Lifted out of `attendance-content.swift` so it can be previewed and
/// re-used independently (also keeps the parent under SwiftLint caps).
struct AttendanceHistoryRow: View {
    let row: AttendanceRow

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: row.status.icon)
                .font(.title2)
                .foregroundStyle(statusColor)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(row.date, style: .date)
                    .font(.headline)

                if let className = row.className {
                    Text(className)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let notes = row.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text(row.status.displayName)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.2))
                .foregroundStyle(statusColor)
                .clipShape(Capsule())
                .accessibilityLabel(String(localized: "a11y.attendance.status \(row.status.displayName)"))
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }

    private var statusColor: Color {
        switch row.status {
        case .present: return .green
        case .absent:  return .red
        case .late:    return .orange
        case .excused: return .blue
        case .sick:    return .purple
        case .holiday: return .gray
        }
    }
}
