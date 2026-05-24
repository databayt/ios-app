import SwiftUI

// MARK: - HWListRow
// Source: Figma iOS 26 — List (node 1:3049)
// Parity: kotlin-app/core/designsystem/atom/list-row.kt

struct HWListRow<Leading: View, Trailing: View>: View {
    let title: String
    var subtitle: String? = nil
    var showDivider: Bool = true
    var onTap: (() -> Void)? = nil
    @ViewBuilder var leading: () -> Leading
    @ViewBuilder var trailing: () -> Trailing

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(spacing: 0) {
                HStack(spacing: AppleSpacing.small) {
                    leading()

                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.body)

                        if let subtitle {
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer(minLength: 0)

                    trailing()
                }
                .padding(.horizontal, AppleSpacing.standard)
                .frame(minHeight: subtitle != nil ? HWRowHeight.subtitle : HWRowHeight.standard)

                if showDivider {
                    Divider()
                        .padding(.leading, AppleSpacing.standard)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Convenience Initializers

extension HWListRow where Leading == EmptyView, Trailing == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        showDivider: Bool = true,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.showDivider = showDivider
        self.onTap = onTap
        self.leading = { EmptyView() }
        self.trailing = { EmptyView() }
    }
}

extension HWListRow where Leading == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        showDivider: Bool = true,
        onTap: (() -> Void)? = nil,
        @ViewBuilder trailing: @escaping () -> Trailing
    ) {
        self.title = title
        self.subtitle = subtitle
        self.showDivider = showDivider
        self.onTap = onTap
        self.leading = { EmptyView() }
        self.trailing = trailing
    }
}

extension HWListRow where Trailing == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        showDivider: Bool = true,
        onTap: (() -> Void)? = nil,
        @ViewBuilder leading: @escaping () -> Leading
    ) {
        self.title = title
        self.subtitle = subtitle
        self.showDivider = showDivider
        self.onTap = onTap
        self.leading = leading
        self.trailing = { EmptyView() }
    }
}

#Preview("List Rows") {
    ScrollView {
        VStack(spacing: 0) {
            HWListRow(title: "Notifications", onTap: {}) {
                Image(systemName: "bell.fill")
                    .foregroundStyle(.accentBlue)
                    .frame(width: 28, height: 28)
            } trailing: {
                Image(systemName: "chevron.forward")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.quaternary)
            }

            HWListRow(
                title: "Ahmed Al-Farsi",
                subtitle: "Grade 10-A · Student",
                onTap: {}
            ) {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.fillTertiary)
            } trailing: {
                Image(systemName: "chevron.forward")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.quaternary)
            }

            HWListRow(title: "Dark Mode") {
                Image(systemName: "moon.fill")
                    .foregroundStyle(.accentPurple)
                    .frame(width: 28, height: 28)
            } trailing: {
                Toggle("", isOn: .constant(true))
                    .labelsHidden()
            }

            HWListRow(title: "Language", showDivider: false, onTap: {}) {
                Image(systemName: "globe")
                    .foregroundStyle(.accentGreen)
                    .frame(width: 28, height: 28)
            } trailing: {
                HStack(spacing: AppleSpacing.tiny) {
                    Text("English")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Image(systemName: "chevron.forward")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.quaternary)
                }
            }
        }
        .background(Color.groupedSecondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: HWShape.card, style: .continuous))
        .padding()
    }
    .background(Color.groupedBackground)
}

#Preview("Plain Rows") {
    ScrollView {
        VStack(spacing: 0) {
            HWListRow(title: "Terms of Service", onTap: {})
            HWListRow(title: "Privacy Policy", onTap: {})
            HWListRow(title: "Sign Out", showDivider: false, onTap: {})
        }
        .background(Color.groupedSecondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: HWShape.card, style: .continuous))
        .padding()
    }
    .background(Color.groupedBackground)
}

#Preview("RTL – Arabic") {
    ScrollView {
        VStack(spacing: 0) {
            HWListRow(title: "الإشعارات", onTap: {}) {
                Image(systemName: "bell.fill")
                    .foregroundStyle(.accentBlue)
                    .frame(width: 28, height: 28)
            } trailing: {
                Image(systemName: "chevron.backward")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.quaternary)
            }

            HWListRow(
                title: "أحمد الفارسي",
                subtitle: "الصف العاشر أ · طالب",
                onTap: {}
            ) {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.fillTertiary)
            } trailing: {
                Image(systemName: "chevron.backward")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.quaternary)
            }

            HWListRow(title: "الوضع الداكن") {
                Image(systemName: "moon.fill")
                    .foregroundStyle(.accentPurple)
                    .frame(width: 28, height: 28)
            } trailing: {
                Toggle("", isOn: .constant(true))
                    .labelsHidden()
            }

            HWListRow(title: "اللغة", showDivider: false, onTap: {}) {
                Image(systemName: "globe")
                    .foregroundStyle(.accentGreen)
                    .frame(width: 28, height: 28)
            } trailing: {
                HStack(spacing: AppleSpacing.tiny) {
                    Text("العربية")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Image(systemName: "chevron.backward")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.quaternary)
                }
            }
        }
        .background(Color.groupedSecondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: HWShape.card, style: .continuous))
        .padding()
    }
    .background(Color.groupedBackground)
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
