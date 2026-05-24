import SwiftUI

// MARK: - HWAlert
// Source: Figma iOS 26 — Alert (node 7:2186)
// Parity: kotlin-app/core/designsystem/atom/hogwarts-alert.kt

struct HWAlert: View {
    let title: String
    let message: String?
    let primaryAction: (label: String, action: () -> Void)
    var secondaryAction: (label: String, action: () -> Void)? = nil

    init(
        title: String,
        message: String? = nil,
        primaryAction: (label: String, action: () -> Void),
        secondaryAction: (label: String, action: () -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    var body: some View {
        VStack(spacing: 0) {
            // Content
            VStack(spacing: AppleSpacing.tiny) {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                if let message {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, AppleSpacing.standard)
            .padding(.top, AppleSpacing.large)
            .padding(.bottom, AppleSpacing.standard)

            Divider()

            // Actions
            if secondaryAction != nil {
                twoButtonLayout
            } else {
                singleButtonLayout
            }
        }
        .frame(width: 270)
        .background(
            .regularMaterial,
            in: RoundedRectangle(cornerRadius: 14, style: .continuous)
        )
    }

    private var singleButtonLayout: some View {
        Button(action: primaryAction.action) {
            Text(primaryAction.label)
                .font(.headline)
                .foregroundStyle(.accentBlue)
                .frame(maxWidth: .infinity)
                .frame(height: HWRowHeight.minTouchTarget)
        }
    }

    private var twoButtonLayout: some View {
        HStack(spacing: 0) {
            if let secondaryAction {
                Button(action: secondaryAction.action) {
                    Text(secondaryAction.label)
                        .font(.body)
                        .foregroundStyle(.accentBlue)
                        .frame(maxWidth: .infinity)
                        .frame(height: HWRowHeight.minTouchTarget)
                }

                Divider()
                    .frame(height: HWRowHeight.minTouchTarget)
            }

            Button(action: primaryAction.action) {
                Text(primaryAction.label)
                    .font(.headline)
                    .foregroundStyle(.accentBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: HWRowHeight.minTouchTarget)
            }
        }
    }
}

#Preview("Single Action") {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()

        VStack(spacing: 24) {
            HWAlert(
                title: "Delete Student",
                message: "This action cannot be undone. All data will be permanently removed.",
                primaryAction: (label: "OK", action: {})
            )

            HWAlert(
                title: "Session Expired",
                primaryAction: (label: "Sign In", action: {})
            )
        }
    }
}

#Preview("Two Actions") {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()

        HWAlert(
            title: "Delete Student",
            message: "This action cannot be undone. All data will be permanently removed.",
            primaryAction: (label: "Delete", action: {}),
            secondaryAction: (label: "Cancel", action: {})
        )
    }
}

#Preview("RTL – Arabic") {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()

        VStack(spacing: 24) {
            HWAlert(
                title: "حذف الطالب",
                message: "لا يمكن التراجع عن هذا الإجراء. سيتم حذف جميع البيانات نهائياً.",
                primaryAction: (label: "حذف", action: {}),
                secondaryAction: (label: "إلغاء", action: {})
            )

            HWAlert(
                title: "انتهت الجلسة",
                message: "يرجى تسجيل الدخول مرة أخرى للمتابعة.",
                primaryAction: (label: "تسجيل الدخول", action: {})
            )
        }
    }
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
