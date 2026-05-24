import SwiftUI

struct AchievementsView: View {
    @State private var viewModel = AchievementsViewModel()
    let tenantContext: TenantContext

    var body: some View {
        List {
            if !viewModel.unlocked.isEmpty {
                Section("quizgame.achievements.unlocked") {
                    ForEach(viewModel.unlocked) { AchievementRow(achievement: $0) }
                }
            }
            if !viewModel.locked.isEmpty {
                Section("quizgame.achievements.in_progress") {
                    ForEach(viewModel.locked) { AchievementRow(achievement: $0) }
                }
            }
        }
        .navigationTitle("quizgame.achievements")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.tenantContext = tenantContext
            await viewModel.load()
        }
    }
}

private struct AchievementRow: View {
    let achievement: QuizAchievement
    var body: some View {
        HStack {
            Image(systemName: achievement.iconName.isEmpty ? "star" : achievement.iconName)
                .font(.title)
                .foregroundStyle(achievement.isUnlocked ? .yellow : .gray)
                .frame(width: 44)
            VStack(alignment: .leading, spacing: 2) {
                Text(achievement.name).font(.subheadline.weight(.semibold))
                Text(achievement.description).font(.caption).foregroundStyle(.secondary)
                if !achievement.isUnlocked {
                    ProgressView(value: achievement.progress).controlSize(.mini)
                }
            }
        }
        .opacity(achievement.isUnlocked ? 1 : 0.6)
    }
}
