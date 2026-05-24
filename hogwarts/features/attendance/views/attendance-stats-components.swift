import SwiftUI

// Stats / toolbar / chip components used by all attendance role views.
// Lives separate from `attendance-content.swift` so the parent stays
// under SwiftLint's 600-line type body cap and so each piece is easy
// to preview and reuse from sibling features later.

// MARK: - Toolbar

struct AttendanceToolbar: View {
    @Bindable var viewModel: AttendanceViewModel

    var body: some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(
                        title: String(localized: "filter.all"),
                        isSelected: viewModel.filters.status == nil,
                        action: { viewModel.filterByStatus(nil) }
                    )
                    .accessibilityLabel(String(localized: "a11y.filter.allStatuses"))
                    .accessibilityAddTraits(viewModel.filters.status == nil ? .isSelected : [])

                    ForEach(AttendanceStatus.allCases, id: \.self) { status in
                        FilterChip(
                            title: status.displayName,
                            isSelected: viewModel.filters.status == status,
                            action: { viewModel.filterByStatus(status) }
                        )
                        .accessibilityLabel(status.displayName)
                        .accessibilityAddTraits(viewModel.filters.status == status ? .isSelected : [])
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - Stats bar (compact, used inline in lists)

struct AttendanceStatsBar: View {
    let stats: AttendanceStatsDisplay

    var body: some View {
        HStack(spacing: 16) {
            StatItem(
                value: "\(Int(stats.attendanceRate))%",
                label: String(localized: "attendance.stats.rate"),
                color: stats.attendanceRate >= 90 ? .green : .orange
            )

            Divider().frame(height: 30)

            StatItem(
                value: "\(stats.presentDays)",
                label: String(localized: "attendance.stats.present"),
                color: .green
            )
            StatItem(
                value: "\(stats.absentDays)",
                label: String(localized: "attendance.stats.absent"),
                color: .red
            )
            StatItem(
                value: "\(stats.lateDays)",
                label: String(localized: "attendance.stats.late"),
                color: .orange
            )
        }
        .padding()
        .background(
            .thinMaterial,
            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 0.5)
        }
        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(localized: "a11y.attendance.statsBar"))
    }
}

// MARK: - Stats card (large, with circular gauge)

struct AttendanceStatsCard: View {
    let stats: AttendanceStatsDisplay

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text(String(localized: "attendance.stats.rate"))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(Int(stats.attendanceRate))%")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(stats.attendanceRate >= 90 ? .green : .orange)
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(.secondary.opacity(0.2), lineWidth: 8)
                    Circle()
                        .trim(from: 0, to: stats.attendanceRate / 100)
                        .stroke(stats.attendanceRate >= 90 ? .green : .orange, lineWidth: 8)
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 60, height: 60)
            }

            HStack(spacing: 20) {
                StatPill(
                    count: stats.presentDays,
                    label: String(localized: "attendance.status.present"),
                    color: .green
                )
                StatPill(
                    count: stats.absentDays,
                    label: String(localized: "attendance.status.absent"),
                    color: .red
                )
                StatPill(
                    count: stats.lateDays,
                    label: String(localized: "attendance.status.late"),
                    color: .orange
                )
            }
        }
        .padding()
        .background(
            .regularMaterial,
            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 0.5)
        }
        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(String(localized: "a11y.attendance.statsCard"))
    }
}

// MARK: - Atomic stat primitives

struct StatItem: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .foregroundStyle(color)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}

struct StatPill: View {
    let count: Int
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text("\(count)")
                .font(.subheadline)
                .fontWeight(.medium)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
