import SwiftUI

struct GameHubContent: View {
    @State private var viewModel = GameHubViewModel()
    let tenantContext: TenantContext

    private let modes = QuizMode.allCases

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if let dc = viewModel.dailyChallenge {
                        DailyChallengeCard(challenge: dc)
                            .padding(.horizontal)
                    }

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(modes) { mode in
                            NavigationLink(value: mode) {
                                ModeTile(mode: mode)
                            }
                        }
                    }
                    .padding(.horizontal)

                    HStack(spacing: 12) {
                        NavigationLink(value: "leaderboard") {
                            FooterTile(icon: "trophy", title: "quizgame.leaderboard")
                        }
                        NavigationLink(value: "achievements") {
                            FooterTile(icon: "star.fill", title: "quizgame.achievements")
                        }
                        NavigationLink(value: "tournaments") {
                            FooterTile(icon: "flag.checkered", title: "quizgame.tournaments")
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("quizgame.title")
            .navigationDestination(for: QuizMode.self) { mode in
                QuizSessionView(mode: mode, tenantContext: tenantContext)
            }
            .navigationDestination(for: String.self) { route in
                switch route {
                case "leaderboard":   LeaderboardView(tenantContext: tenantContext)
                case "achievements":  AchievementsView(tenantContext: tenantContext)
                case "tournaments":   TournamentsView(tenantContext: tenantContext)
                default: EmptyView()
                }
            }
            .task {
                viewModel.tenantContext = tenantContext
                await viewModel.load()
            }
        }
    }
}

private struct DailyChallengeCard: View {
    let challenge: DailyChallenge
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("quizgame.daily_challenge", systemImage: "calendar")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.85))
            Text(challenge.subject).font(.title3.weight(.bold)).foregroundStyle(.white)
            HStack {
                Label("\(challenge.questionCount)", systemImage: "questionmark.circle")
                Spacer()
                Label("\(challenge.reward) XP", systemImage: "bolt.fill")
            }
            .font(.caption)
            .foregroundStyle(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

private struct ModeTile: View {
    let mode: QuizMode
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon).font(.title)
            Text(mode.rawValue.capitalized).font(.subheadline.weight(.medium))
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    private var icon: String {
        switch mode {
        case .practice:   "graduationcap"
        case .timed:      "timer"
        case .challenge:  "flame"
        case .tournament: "flag.checkered"
        }
    }
}

private struct FooterTile: View {
    let icon: String
    let title: LocalizedStringKey
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
            Text(title).font(.caption2)
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
