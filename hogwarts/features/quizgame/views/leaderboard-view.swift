import SwiftUI

struct LeaderboardView: View {
    @State private var viewModel = LeaderboardViewModel()
    let tenantContext: TenantContext

    var body: some View {
        List(viewModel.entries) { entry in
            HStack {
                Text("#\(entry.rank)").font(.caption.weight(.bold)).frame(width: 36)
                if let avatar = entry.avatarUrl, let u = URL(string: avatar) {
                    AsyncImage(url: u) { img in img.resizable() } placeholder: { Color.gray.opacity(0.2) }
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                } else {
                    Circle().fill(.gray.opacity(0.3)).frame(width: 32, height: 32)
                        .overlay(Image(systemName: "person").foregroundStyle(.secondary))
                }
                VStack(alignment: .leading) {
                    Text(entry.userName).font(.subheadline)
                    Text("\(entry.gamesPlayed) games · \(Int(entry.winRate * 100))%")
                        .font(.caption2).foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(entry.score)").font(.headline.monospacedDigit())
            }
        }
        .navigationTitle("quizgame.leaderboard")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Picker("scope", selection: $viewModel.scope) {
                    Text("quizgame.scope.school").tag("school")
                    Text("quizgame.scope.global").tag("global")
                }
                .onChange(of: viewModel.scope) { Task { await viewModel.load() } }
            }
        }
        .task {
            viewModel.tenantContext = tenantContext
            await viewModel.load()
        }
    }
}
