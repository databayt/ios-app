import SwiftUI

/// Root view for the Messages tab — wires the existing MessagesViewModel into the
/// iOS WhatsApp chat-list UI. Replaces the previous MessagesContent in MainTabView.
struct WaMessagesTabRoot: View {
    @Environment(AuthManager.self) private var authManager
    @Environment(TenantContext.self) private var tenantContext
    @State private var viewModel = MessagesViewModel()
    @State private var activeConversation: Conversation?

    var body: some View {
        NavigationStack {
            WhatsAppChatListView(
                rows: rows,
                archivedCount: 0,
                onRowTap: { id in
                    if let conv = viewModel.conversations.first(where: { $0.id == id }) {
                        activeConversation = conv
                    }
                },
                onNewChat: { viewModel.showCompose() },
                onCamera: { },
                onOptions: { }
            )
            .navigationDestination(item: $activeConversation) { conversation in
                ChatView(conversation: conversation)
            }
            .sheet(isPresented: $viewModel.isShowingCompose) {
                ComposeMessageView(
                    onConversationCreated: { conversation in
                        viewModel.onConversationCreated(conversation)
                    }
                )
            }
            .task {
                viewModel.setup(tenantContext: tenantContext, authManager: authManager)
                await viewModel.loadConversations()
            }
        }
        .environment(\.whatsAppColors, .light)
    }

    private var rows: [IosChatRowData] {
        let currentUserId = authManager.session?.user.id
        return viewModel.conversations.map { conv in
            IosChatRowData(
                conversation: conv,
                typingIds: [],
                mentionedIds: [],
                onlineUserIds: [],
                locale: .current,
                currentUserId: currentUserId
            )
        }
    }
}
