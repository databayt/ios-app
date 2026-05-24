import Foundation

extension IosChatRowData {
    /// Build from the existing `Conversation` domain model.
    init(
        conversation: Conversation,
        typingIds: Set<String> = [],
        mentionedIds: Set<String> = [],
        onlineUserIds: Set<String> = [],
        locale: Locale = .current,
        currentUserId: String? = nil
    ) {
        let isTyping = typingIds.contains(conversation.id)
        let isMentioned = mentionedIds.contains(conversation.id)
        let otherParticipant = conversation.participants?.first(where: { $0.userId != currentUserId })
        let isOnline = otherParticipant.map { onlineUserIds.contains($0.userId) } ?? false

        let previewText: String
        let previewLeading: IosPreviewLeading?
        let previewItalic: Bool

        if isTyping {
            previewText = String(localized: "messages.typing")
            previewLeading = nil
            previewItalic = true
        } else if let last = conversation.lastMessage {
            previewText = last.content
            previewLeading = nil
            previewItalic = false
        } else {
            previewText = ""
            previewLeading = nil
            previewItalic = false
        }

        let name = conversation.displayName
        let fallback = String(name.prefix(1)).uppercased()

        self.init(
            id: conversation.id,
            name: name,
            avatarUrl: otherParticipant?.imageUrl,
            avatarFallback: fallback,
            isGroup: conversation.isGroup,
            online: isOnline,
            preview: previewText,
            previewLeading: previewLeading,
            previewItalic: previewItalic,
            timestamp: IosChatRowData.formatTimestamp(conversation.lastMessage?.createdAt ?? conversation.updatedAt, locale: locale),
            unreadCount: conversation.unreadCount,
            mentioned: isMentioned,
            pinned: false,
            muted: false
        )
    }

    static func formatTimestamp(_ date: Date, locale: Locale) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(date) {
            let f = DateFormatter()
            f.locale = locale
            f.dateFormat = "HH:mm"
            return f.string(from: date)
        }
        if cal.isDateInYesterday(date) {
            return locale.language.languageCode?.identifier == "ar" ? "أمس" : "Yesterday"
        }
        let f = DateFormatter()
        f.locale = locale
        f.setLocalizedDateFormatFromTemplate("dd/MM")
        return f.string(from: date)
    }
}
