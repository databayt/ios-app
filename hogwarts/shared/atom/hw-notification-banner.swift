import SwiftUI

// MARK: - HWNotificationBanner
// Source: Figma iOS 26 — Notification (node 4:1613)
// Parity: kotlin-app/core/designsystem/atom/notification-banner.kt

struct HWNotificationBanner: View {
    let title: String
    let description: String
    var time: String? = nil
    var icon: Image? = nil
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 10) {
                // App icon
                if let icon {
                    icon
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 38, height: 38)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }

                // Text content
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(title)
                            .font(.subheadline.weight(.semibold))
                            .lineLimit(1)

                        Spacer(minLength: AppleSpacing.tiny)

                        if let time {
                            Text(time)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, AppleSpacing.small)
            .frame(minHeight: 64)
        }
        .buttonStyle(.plain)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
        .shadow(color: .black.opacity(0.2), radius: 20, y: 8)
    }
}

#Preview("Notification Banner") {
    ZStack {
        Color.groupedBackground.ignoresSafeArea()

        VStack(spacing: 16) {
            HWNotificationBanner(
                title: "Hogwarts",
                description: "Ahmed submitted his admission application.",
                time: "2m ago",
                icon: Image(systemName: "graduationcap.fill"),
                onTap: {}
            )

            HWNotificationBanner(
                title: "Attendance",
                description: "3 students marked absent in Grade 10-A today.",
                time: "5m ago",
                icon: Image(systemName: "person.badge.clock"),
                onTap: {}
            )

            HWNotificationBanner(
                title: "System",
                description: "Your session will expire in 5 minutes. Please save your work.",
                icon: Image(systemName: "exclamationmark.triangle.fill")
            )
        }
        .padding()
    }
}

#Preview("RTL – Arabic") {
    ZStack {
        Color.groupedBackground.ignoresSafeArea()

        VStack(spacing: 16) {
            HWNotificationBanner(
                title: "هوقورتس",
                description: "أحمد قدّم طلب القبول الخاص به.",
                time: "منذ ٢ د",
                icon: Image(systemName: "graduationcap.fill"),
                onTap: {}
            )

            HWNotificationBanner(
                title: "الحضور",
                description: "تم تسجيل ٣ طلاب غائبين في الصف العاشر أ اليوم.",
                time: "منذ ٥ د",
                icon: Image(systemName: "person.badge.clock"),
                onTap: {}
            )

            HWNotificationBanner(
                title: "النظام",
                description: "ستنتهي جلستك خلال ٥ دقائق. يرجى حفظ عملك.",
                icon: Image(systemName: "exclamationmark.triangle.fill")
            )
        }
        .padding()
    }
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
