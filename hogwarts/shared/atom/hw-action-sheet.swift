import SwiftUI

// MARK: - HWActionSheet
// Source: Figma iOS 26 — Action Sheet (node 1:58)
// Parity: kotlin-app/core/designsystem/atom/action-sheet.kt

struct HWActionSheetAction: Identifiable {
    let id = UUID()
    let label: String
    var isDestructive: Bool = false
    let action: () -> Void
}

struct HWActionSheet: View {
    let title: String
    var message: String? = nil
    let actions: [HWActionSheetAction]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: AppleSpacing.tiny) {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                if let message {
                    Text(message)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 14)
            .padding(.top, AppleSpacing.standard)
            .padding(.bottom, AppleSpacing.small)

            // Actions
            VStack(spacing: 10) {
                ForEach(actions) { action in
                    Button(action: action.action) {
                        Text(action.label)
                            .font(.body.weight(.medium))
                            .foregroundStyle(action.isDestructive ? .hogwartsError : .primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                Color(uiColor: .secondarySystemFill),
                                in: Capsule()
                            )
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
        .background(
            .regularMaterial,
            in: RoundedRectangle(cornerRadius: 34, style: .continuous)
        )
    }
}

#Preview("Action Sheet") {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()

        VStack {
            Spacer()

            HWActionSheet(
                title: "Student Options",
                message: "Choose an action for this student record.",
                actions: [
                    HWActionSheetAction(label: "Edit Profile") {},
                    HWActionSheetAction(label: "View Grades") {},
                    HWActionSheetAction(label: "Contact Parent") {},
                    HWActionSheetAction(label: "Remove Student", isDestructive: true) {},
                ]
            )
            .padding(.horizontal, AppleSpacing.compact)
            .padding(.bottom, AppleSpacing.large)
        }
    }
}

#Preview("Minimal") {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()

        VStack {
            Spacer()

            HWActionSheet(
                title: "Share Attendance Report",
                actions: [
                    HWActionSheetAction(label: "Export as PDF") {},
                    HWActionSheetAction(label: "Send via Email") {},
                ]
            )
            .padding(.horizontal, AppleSpacing.compact)
            .padding(.bottom, AppleSpacing.large)
        }
    }
}

#Preview("RTL – Arabic") {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()

        VStack {
            Spacer()

            HWActionSheet(
                title: "خيارات الطالب",
                message: "اختر إجراءً لسجل الطالب.",
                actions: [
                    HWActionSheetAction(label: "تعديل الملف الشخصي") {},
                    HWActionSheetAction(label: "عرض الدرجات") {},
                    HWActionSheetAction(label: "التواصل مع ولي الأمر") {},
                    HWActionSheetAction(label: "حذف الطالب", isDestructive: true) {},
                ]
            )
            .padding(.horizontal, AppleSpacing.compact)
            .padding(.bottom, AppleSpacing.large)
        }
    }
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
