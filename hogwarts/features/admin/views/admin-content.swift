import SwiftUI

// MARK: - AdminContent
//
// Admin home: stats card, school identity card, staff section preview,
// classes section preview. Mirrors web admin dashboard but trimmed for
// mobile — explicit "View all" links push the long lists.

struct AdminContent: View {
    @State private var viewModel = AdminViewModel()
    @Environment(\.locale) private var locale

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let stats = viewModel.stats {
                    StatsCard(stats: stats)
                }
                if let school = viewModel.school {
                    SchoolCard(school: school, locale: locale)
                }
                staffSection
                classesSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .overlay { if viewModel.isLoading && viewModel.stats == nil { ProgressView() } }
        .navigationTitle(Text("admin.title"))
        .navigationBarTitleDisplayMode(.large)
        .task { if viewModel.stats == nil { await viewModel.loadAll() } }
        .refreshable { await viewModel.loadAll() }
    }

    // MARK: - Sections

    private var staffSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("admin.section.staff").font(.headline)
                Spacer()
                NavigationLink(value: AdminRoute.staff) {
                    Text("admin.viewAll").font(.subheadline)
                }
            }
            if viewModel.staff.isEmpty {
                Text("admin.staff.empty")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                VStack(spacing: 0) {
                    ForEach(viewModel.staff.prefix(5)) { member in
                        StaffRow(member: member)
                        if member.id != viewModel.staff.prefix(5).last?.id {
                            Divider().padding(.leading, 60)
                        }
                    }
                }
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
    }

    private var classesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("admin.section.classes").font(.headline)
                Spacer()
                NavigationLink(value: AdminRoute.classes) {
                    Text("admin.viewAll").font(.subheadline)
                }
            }
            if viewModel.classes.isEmpty {
                Text("admin.classes.empty")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                VStack(spacing: 0) {
                    ForEach(viewModel.classes.prefix(5)) { cls in
                        ClassRow(item: cls)
                        if cls.id != viewModel.classes.prefix(5).last?.id {
                            Divider().padding(.leading, 60)
                        }
                    }
                }
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
    }
}

// MARK: - Stats card

private struct StatsCard: View {
    let stats: AdminStats

    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 10) {
                statTile(value: "\(stats.totalStudents)",
                         label: "admin.stat.students", tint: .accentBlue)
                statTile(value: "\(stats.totalTeachers)",
                         label: "admin.stat.teachers", tint: .accentPurple)
                statTile(value: "\(stats.totalSections)",
                         label: "admin.stat.sections", tint: .accentOrange)
            }
            HStack(spacing: 10) {
                statTile(value: "\(stats.todayAttendanceRate.formatted(.number.precision(.fractionLength(1))))%",
                         label: "admin.stat.todayAttendance",
                         tint: stats.todayAttendanceRate >= 90 ? .accentGreen : .accentOrange)
                statTile(value: "\(stats.upcomingExams)",
                         label: "admin.stat.upcomingExams", tint: .accentRed)
                statTile(value: "\(stats.activeConversations)",
                         label: "admin.stat.activeConversations", tint: .accentTeal)
            }
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func statTile(value: String, label: LocalizedStringResource, tint: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.weight(.heavy))
                .monospacedDigit()
                .foregroundStyle(tint)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 10).fill(tint.opacity(0.08)))
    }
}

// MARK: - School card

private struct SchoolCard: View {
    let school: AdminSchool
    let locale: Locale

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(Color.accentBlue.opacity(0.15))
                Image(systemName: "graduationcap.fill")
                    .foregroundStyle(.accentColor)
                    .font(.title3)
            }
            .frame(width: 44, height: 44)
            VStack(alignment: .leading, spacing: 4) {
                Text(school.displayName(for: locale))
                    .font(.body.weight(.semibold))
                if let domain = school.domain, !domain.isEmpty {
                    Text(domain)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospaced()
                }
            }
            Spacer()
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

// MARK: - Rows

private struct StaffRow: View {
    let member: AdminStaffMember

    var body: some View {
        HStack(spacing: 12) {
            avatar
                .frame(width: 36, height: 36)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(member.fullName).font(.subheadline.weight(.medium))
                if let position = member.position ?? member.department ?? member.subject {
                    Text(position).font(.caption).foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text(member.roleKind.label)
                .font(.caption2.weight(.semibold))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Capsule().fill(member.roleKind.color.opacity(0.15)))
                .foregroundStyle(member.roleKind.color)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private var avatar: some View {
        if let url = member.photoUrl, let parsed = URL(string: url) {
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
            Color.accentColor.opacity(0.15)
            Image(systemName: "person.fill")
                .foregroundStyle(.tint)
                .font(.subheadline)
        }
    }
}

private struct ClassRow: View {
    let item: AdminClass

    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 0) {
                Text(item.grade?.number.map { "G\($0)" } ?? "—")
                    .font(.caption2.weight(.bold))
                Text(item.letter ?? item.name.prefix(1).uppercased())
                    .font(.title3.weight(.heavy))
            }
            .frame(width: 44, height: 44)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentBlue.opacity(0.12)))
            .foregroundStyle(Color.accentBlue)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name).font(.subheadline.weight(.medium))
                if let teacher = item.homeroomTeacher {
                    Label(teacher.name, systemImage: "person.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 0) {
                Text("\(item.studentCount)")
                    .font(.body.weight(.semibold))
                    .monospacedDigit()
                Text("admin.classes.studentCount")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}

// MARK: - Routing

enum AdminRoute: Hashable {
    case staff
    case classes
}

#Preview("LTR") { NavigationStack { AdminContent() } }
#Preview("RTL") {
    NavigationStack { AdminContent() }
        .environment(\.layoutDirection, .rightToLeft)
}
