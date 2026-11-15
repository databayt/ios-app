import SwiftUI

/// `/live/[id]` — title, when, status, facts, and Join. Join presents the room full screen.
struct LiveSessionContent: View {
    @State private var viewModel: LiveSessionViewModel
    @State private var showRoom = false
    @Environment(\.openURL) private var openURL

    init(sessionId: String) {
        _viewModel = State(initialValue: LiveSessionViewModel(sessionId: sessionId))
    }

    var body: some View {
        ScrollView {
            if let page = viewModel.page {
                VStack(alignment: .leading, spacing: 16) {
                    header(page)
                    if let description = page.description, !description.isEmpty {
                        Text(description).font(.body)
                    }
                    facts(page)
                    if let note = page.attendanceNote, !note.isEmpty {
                        Text(note)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.quaternary))
                    }
                    joinButton(page)
                }
                .padding()
            } else if viewModel.isLoading {
                ProgressView().frame(maxWidth: .infinity, minHeight: 200)
            } else if let error = viewModel.error {
                Text(error).foregroundStyle(.red).padding()
            }
        }
        .navigationTitle(viewModel.page?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable { await viewModel.load() }
        .task { await viewModel.load() }
        .fullScreenCover(isPresented: $showRoom, onDismiss: { Task { await viewModel.load() } }) {
            LiveRoomView(sessionId: viewModel.sessionId, title: viewModel.page?.title ?? "") {
                showRoom = false
            }
        }
    }

    private func header(_ page: SessionPage) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(page.title).font(.title2.bold())
            HStack(spacing: 8) {
                if page.status == "live" { LiveBadge() }
                else if !page.statusLabel.isEmpty {
                    Text(page.statusLabel)
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10).padding(.vertical, 3)
                        .background(Color.accentColor.opacity(0.15), in: Capsule())
                }
                if !page.when.isEmpty {
                    Text(page.when).font(.subheadline).foregroundStyle(.secondary)
                }
            }
        }
    }

    private func facts(_ page: SessionPage) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(page.rows.enumerated()), id: \.offset) { _, row in
                VStack(alignment: .leading, spacing: 2) {
                    Text(row.label).font(.caption).foregroundStyle(.secondary)
                    Text(row.value).font(.subheadline)
                }
            }
        }
    }

    @ViewBuilder
    private func joinButton(_ page: SessionPage) -> some View {
        if page.canJoin {
            Button {
                if page.isExternal, let url = page.meetingURL.flatMap(URL.init(string:)) {
                    openURL(url)
                } else {
                    showRoom = true
                }
            } label: {
                Label(
                    page.labels["enter"] ?? page.labels["join"] ?? String(localized: "live.session.join"),
                    systemImage: "video.fill"
                )
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
