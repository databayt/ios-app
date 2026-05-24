import SwiftUI

// MARK: - AttendanceGamificationView
//
// Hero card (current streak + longest + earned points) above two badge
// grids: Earned (showing badge art + earned date) and Locked (greyed,
// showing description + point value to motivate). Mirrors Android's
// gamification module.

struct AttendanceGamificationView: View {
    var studentId: String?

    @State private var viewModel = AttendanceGamificationViewModel()
    @Environment(\.locale) private var locale

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroCard
                if !viewModel.earnedBadges.isEmpty {
                    badgesSection(
                        title: "gamification.section.earned",
                        badges: viewModel.earnedBadges,
                        earned: true
                    )
                }
                if !viewModel.unearnedBadges.isEmpty {
                    badgesSection(
                        title: "gamification.section.locked",
                        badges: viewModel.unearnedBadges,
                        earned: false
                    )
                }
                if viewModel.badges.isEmpty && !viewModel.isLoading {
                    emptyState
                }
                if let error = viewModel.lastError {
                    errorBanner(error)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .overlay { if viewModel.isLoading && viewModel.badges.isEmpty { ProgressView() } }
        .navigationTitle(Text("gamification.title"))
        .navigationBarTitleDisplayMode(.inline)
        .task { if viewModel.badges.isEmpty { await viewModel.load(studentId: studentId) } }
        .refreshable { await viewModel.load(studentId: studentId) }
    }

    // MARK: - Hero

    @ViewBuilder
    private var heroCard: some View {
        let streak = viewModel.streak
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundStyle(.orange)
                Text("gamification.streak.title")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
                    .textCase(.uppercase)
            }

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(streak?.currentStreak ?? 0)")
                    .font(.system(size: 52, weight: .heavy, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                Text(LocalizedStringResource("gamification.streak.daysSuffix"))
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
            }

            HStack(spacing: 14) {
                heroStat(value: "\(streak?.longestStreak ?? 0)",
                         label: "gamification.stat.longest")
                Spacer()
                heroStat(value: "\(viewModel.earnedPoints)",
                         label: "gamification.stat.points")
                Spacer()
                if let rate = streak?.monthlyAttendanceRate {
                    heroStat(
                        value: rate.formatted(.percent.precision(.fractionLength(0))),
                        label: "gamification.stat.thisMonth"
                    )
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [.orange, .red.opacity(0.8)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func heroStat(value: String, label: LocalizedStringResource) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.subheadline.weight(.bold))
                .monospacedDigit()
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Badges grid

    private func badgesSection(title: LocalizedStringResource, badges: [AttendanceBadge], earned: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(badges) { badge in
                    BadgeTile(badge: badge, earned: earned, locale: locale)
                }
            }
        }
    }

    // MARK: - States

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "rosette")
                .font(.system(size: 44))
                .foregroundStyle(.tertiary)
            Text("gamification.empty.title").font(.headline)
            Text("gamification.empty.subtitle")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }

    private func errorBanner(_ message: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(String(localized: "gamification.error.title"), systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
            Text(message).font(.caption).foregroundStyle(.secondary)
            Button(String(localized: "gamification.retry")) {
                Task { await viewModel.load(studentId: studentId) }
            }
            .buttonStyle(.bordered)
            .padding(.top, 4)
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// MARK: - Tile

private struct BadgeTile: View {
    let badge: AttendanceBadge
    let earned: Bool
    let locale: Locale

    var tint: Color {
        Color(hex: badge.color) ?? Color.deterministic(from: badge.id)
    }

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(earned ? tint.opacity(0.18) : Color(uiColor: .tertiarySystemFill))
                Image(systemName: badge.icon ?? "rosette")
                    .font(.title2)
                    .foregroundStyle(earned ? tint : .secondary)
            }
            .frame(width: 56, height: 56)
            .opacity(earned ? 1.0 : 0.55)

            Text(badge.name)
                .font(.caption.weight(.semibold))
                .foregroundStyle(earned ? .primary : .secondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            if let points = badge.pointValue, points > 0 {
                Text("gamification.badge.points \(points)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            if earned, let earnedAt = badge.earnedAt {
                Text(earnedAt.formatted(.relative(presentation: .named).locale(locale)))
                    .font(.caption2)
                    .foregroundStyle(tint)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(badge.name))
        .accessibilityValue(Text(earned
                                  ? "gamification.badge.earned"
                                  : "gamification.badge.locked"))
    }
}

#Preview("LTR") { NavigationStack { AttendanceGamificationView() } }
#Preview("RTL") {
    NavigationStack { AttendanceGamificationView() }
        .environment(\.layoutDirection, .rightToLeft)
}
