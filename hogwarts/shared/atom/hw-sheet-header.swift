import SwiftUI

// MARK: - HWSheetHeader
// Source: Figma iOS 26 — Sheet (node 8:2369)
// Parity: kotlin-app/core/designsystem/atom/sheet-header.kt

struct HWSheetHeader: View {
    let title: String
    var showGrabber: Bool = true
    var onClose: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            if showGrabber {
                grabber
                    .padding(.top, AppleSpacing.compact)
            }

            HStack {
                Text(title)
                    .font(.title3.weight(.semibold))

                Spacer()

                if let onClose {
                    closeButton(action: onClose)
                }
            }
            .padding(.horizontal, AppleSpacing.standard)
            .padding(.top, showGrabber ? AppleSpacing.small : 14)
            .padding(.bottom, AppleSpacing.small)
        }
    }

    private var grabber: some View {
        RoundedRectangle(cornerRadius: 2.5, style: .continuous)
            .fill(.quaternary)
            .frame(width: 36, height: 5)
    }

    private func closeButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.secondary)
                .frame(width: 30, height: 30)
                .background(
                    .fillTertiary,
                    in: Circle()
                )
        }
    }
}

#Preview("With Grabber") {
    VStack(spacing: 0) {
        HWSheetHeader(title: "Student Details", onClose: {})

        Divider()

        Spacer()

        Text("Sheet content goes here")
            .foregroundStyle(.secondary)

        Spacer()
    }
    .background(Color.groupedBackground)
}

#Preview("No Grabber") {
    VStack(spacing: 0) {
        HWSheetHeader(title: "Filters", showGrabber: false, onClose: {})

        Divider()

        Spacer()
    }
    .background(Color.groupedBackground)
}

#Preview("Title Only") {
    VStack(spacing: 0) {
        HWSheetHeader(title: "Attendance Report")

        Divider()

        Spacer()
    }
    .background(Color.groupedBackground)
}

#Preview("RTL – Arabic") {
    VStack(spacing: 0) {
        HWSheetHeader(title: "تفاصيل الطالب", onClose: {})

        Divider()

        HWSheetHeader(title: "الفلاتر", showGrabber: false, onClose: {})

        Divider()

        HWSheetHeader(title: "تقرير الحضور")

        Divider()

        Spacer()
    }
    .background(Color.groupedBackground)
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
