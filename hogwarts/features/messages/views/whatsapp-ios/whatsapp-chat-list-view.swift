import SwiftUI

/// iOS WhatsApp-style chat list screen.
/// Mirrors Figma: HqgFh4Lxp8QtTnW04czQQN node 124:1406
struct WhatsAppChatListView: View {
    let rows: [IosChatRowData]
    let archivedCount: Int
    var onRowTap: (String) -> Void = { _ in }
    var onNewChat: () -> Void = {}
    var onCamera: () -> Void = {}
    var onOptions: () -> Void = {}
    var onOpenArchived: () -> Void = {}
    var onBackToDashboard: () -> Void = {}

    @State private var searchText: String = ""
    @State private var activeFilter: WaFilterId = .all
    @State private var activeTab: IosTabId = .chats
    @Environment(\.whatsAppColors) private var wa

    init(
        rows: [IosChatRowData],
        archivedCount: Int = 0,
        onRowTap: @escaping (String) -> Void = { _ in },
        onNewChat: @escaping () -> Void = {},
        onCamera: @escaping () -> Void = {},
        onOptions: @escaping () -> Void = {},
        onOpenArchived: @escaping () -> Void = {},
        onBackToDashboard: @escaping () -> Void = {}
    ) {
        self.rows = rows
        self.archivedCount = archivedCount
        self.onRowTap = onRowTap
        self.onNewChat = onNewChat
        self.onCamera = onCamera
        self.onOptions = onOptions
        self.onOpenArchived = onOpenArchived
        self.onBackToDashboard = onBackToDashboard
    }

    private var filtered: [IosChatRowData] {
        let q = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        return rows.filter { row in
            switch activeFilter {
            case .all: break
            case .unread: if row.unreadCount == 0 { return false }
            case .favourites: if !row.pinned { return false }
            case .groups: if !row.isGroup { return false }
            }
            if q.isEmpty { return true }
            return row.name.lowercased().contains(q)
        }
    }

    private var totalUnread: Int {
        rows.reduce(0) { $0 + $1.unreadCount }
    }

    private var tabs: [IosTab] {
        [
            IosTab(id: .calls,   label: "Calls",   systemImage: "phone.fill", badge: nil),
            IosTab(id: .classes, label: "Classes", systemImage: "person.2.fill", badge: nil),
            IosTab(id: .chats,   label: "Chats",   systemImage: "bubble.left.and.bubble.right.fill", badge: totalUnread > 0 ? totalUnread : nil),
            IosTab(id: .back,    label: "Back",    systemImage: "gearshape.fill", badge: nil),
        ]
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            wa.surfacePrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                IosHeader(
                    showOptions: true,
                    showCamera: true,
                    showAdd: true,
                    onOptions: onOptions,
                    onCamera: onCamera,
                    onAdd: onNewChat
                )

                ScrollView {
                    VStack(spacing: 0) {
                        IosTitleBlock(
                            title: "Chats",
                            searchPlaceholder: "Search messages",
                            searchText: $searchText,
                            activeFilter: activeFilter,
                            filterLabels: [
                                .all: "All",
                                .unread: "Unread",
                                .favourites: "Favourites",
                                .groups: "Groups",
                            ],
                            onFilterChange: { activeFilter = $0 },
                            onAddFilter: nil
                        )

                        IosArchivedRow(
                            label: "Archived",
                            count: archivedCount > 0 ? archivedCount : nil,
                            onTap: onOpenArchived
                        )

                        ForEach(filtered) { row in
                            IosChatRow(row: row) { onRowTap(row.id) }
                        }

                        IosInfoEncrypt()
                            .padding(.top, 18)
                            .padding(.bottom, 32)
                    }
                }

                IosTabbar(tabs: tabs, active: activeTab) { tab in
                    if tab == .back {
                        onBackToDashboard()
                    } else {
                        activeTab = tab
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview("EN Light") {
    WhatsAppChatListView(
        rows: .preview,
        archivedCount: 0
    )
    .environment(\.whatsAppColors, .light)
}

#Preview("AR RTL") {
    WhatsAppChatListView(
        rows: .preview,
        archivedCount: 2
    )
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.whatsAppColors, .light)
}

#Preview("Dark") {
    WhatsAppChatListView(
        rows: .preview,
        archivedCount: 0
    )
    .environment(\.whatsAppColors, .dark)
    .preferredColorScheme(.dark)
}

extension Array where Element == IosChatRowData {
    static var preview: [IosChatRowData] {
        [
            IosChatRowData(id: "c1", name: "Jenny ❤️", avatarUrl: nil, avatarFallback: "J", isGroup: false, online: true,
                preview: #"You reacted 😘 to "That's good advice, Marty.""#,
                previewLeading: nil, previewItalic: false, timestamp: "16:14",
                unreadCount: 0, mentioned: false, pinned: true, muted: false),
            IosChatRowData(id: "c2", name: "Mom 💕", avatarUrl: nil, avatarFallback: "M", isGroup: false, online: false,
                preview: "is typing...",
                previewLeading: nil, previewItalic: true, timestamp: "19:45",
                unreadCount: 1, mentioned: true, pinned: false, muted: false),
            IosChatRowData(id: "c3", name: "Daddy", avatarUrl: nil, avatarFallback: "D", isGroup: false, online: false,
                preview: "I mean he wrecked it! 😭",
                previewLeading: .checkRead, previewItalic: false, timestamp: "19:42",
                unreadCount: 0, mentioned: false, pinned: false, muted: false),
            IosChatRowData(id: "c4", name: "Biff Tannen", avatarUrl: nil, avatarFallback: "B", isGroup: false, online: false,
                preview: "Say hi to your mom for me.",
                previewLeading: nil, previewItalic: false, timestamp: "18:23",
                unreadCount: 0, mentioned: false, pinned: false, muted: false),
            IosChatRowData(id: "c5", name: "Clocktower Lady", avatarUrl: nil, avatarFallback: "C", isGroup: false, online: false,
                preview: "Save the clock tower?",
                previewLeading: .voice, previewItalic: false, timestamp: "16:15",
                unreadCount: 0, mentioned: false, pinned: false, muted: false),
            IosChatRowData(id: "c6", name: "Mr. Strickland", avatarUrl: nil, avatarFallback: "M", isGroup: false, online: false,
                preview: "You deleted this message.",
                previewLeading: .deleted, previewItalic: true, timestamp: "08:57",
                unreadCount: 0, mentioned: false, pinned: false, muted: false),
            IosChatRowData(id: "c7", name: #"Emmett "Doc" Brown"#, avatarUrl: nil, avatarFallback: "E", isGroup: false, online: false,
                preview: "Location",
                previewLeading: .location, previewItalic: false, timestamp: "08:24",
                unreadCount: 0, mentioned: false, pinned: false, muted: false),
            IosChatRowData(id: "c8", name: "Dave", avatarUrl: nil, avatarFallback: "D", isGroup: false, online: false,
                preview: "Thanks bro!",
                previewLeading: nil, previewItalic: false, timestamp: "08:01",
                unreadCount: 0, mentioned: false, pinned: false, muted: false),
            IosChatRowData(id: "c9", name: "Lynda", avatarUrl: nil, avatarFallback: "L", isGroup: false, online: false,
                preview: "Ok!",
                previewLeading: .checkSent, previewItalic: false, timestamp: "Yesterday",
                unreadCount: 0, mentioned: false, pinned: false, muted: false),
            IosChatRowData(id: "c10", name: "The time travelers ⏰", avatarUrl: nil, avatarFallback: "T", isGroup: true, online: false,
                preview: "Titor: ...until the clock hits 2:17 AM, March 14th, 2036.",
                previewLeading: nil, previewItalic: false, timestamp: "Yesterday",
                unreadCount: 0, mentioned: false, pinned: false, muted: false),
        ]
    }
}
