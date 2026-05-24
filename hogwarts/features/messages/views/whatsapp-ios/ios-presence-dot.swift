import SwiftUI

struct IosPresenceDot: View {
    let online: Bool
    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        if online {
            Circle()
                .fill(wa.surfaceProduct)
                .frame(width: 14, height: 14)
                .overlay(
                    Circle()
                        .stroke(wa.surfacePrimary, lineWidth: 2)
                )
                .accessibilityLabel("Online")
        }
    }
}
