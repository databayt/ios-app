import SwiftUI

// MARK: - HWOverlay
// Source: Figma iOS 26 — Overlay (node 16:3081)
// Parity: kotlin-app/core/designsystem/atom/overlay.kt

struct HWOverlay: View {
    var isPresented: Bool = true
    var onTap: (() -> Void)? = nil

    var body: some View {
        if isPresented {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
                .onTapGesture {
                    onTap?()
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: isPresented)
        }
    }
}

#Preview("Overlay") {
    ZStack {
        VStack(spacing: AppleSpacing.standard) {
            Text("Background Content")
                .font(.title2.weight(.bold))
            Text("This is behind the overlay")
                .foregroundStyle(.secondary)
        }

        HWOverlay()

        Text("Modal Content")
            .font(.headline)
            .padding(AppleSpacing.large)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: HWShape.card, style: .continuous))
    }
}

#Preview("RTL – Arabic") {
    ZStack {
        VStack(spacing: AppleSpacing.standard) {
            Text("محتوى الخلفية")
                .font(.title2.weight(.bold))
            Text("هذا خلف الطبقة")
                .foregroundStyle(.secondary)
        }

        HWOverlay()

        Text("محتوى النافذة")
            .font(.headline)
            .padding(AppleSpacing.large)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: HWShape.card, style: .continuous))
    }
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
