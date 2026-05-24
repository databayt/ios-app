import SwiftUI

struct TournamentsView: View {
    @State private var viewModel = TournamentsViewModel()
    let tenantContext: TenantContext

    var body: some View {
        List(viewModel.tournaments) { t in
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(t.name).font(.headline)
                    Spacer()
                    Text(t.status.rawValue.capitalized)
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(statusColor(t.status).opacity(0.15))
                        .foregroundStyle(statusColor(t.status))
                        .clipShape(Capsule())
                }
                Text(t.subject).font(.caption).foregroundStyle(.secondary)
                HStack(spacing: 12) {
                    Label("\(t.participants)", systemImage: "person.3")
                    Label("R\(t.currentRound)/\(t.totalRounds)", systemImage: "list.bullet")
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("quizgame.tournaments")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.tenantContext = tenantContext
            await viewModel.load()
        }
    }

    private func statusColor(_ status: TournamentStatus) -> Color {
        switch status {
        case .upcoming:   .blue
        case .inProgress: .orange
        case .completed:  .gray
        }
    }
}
