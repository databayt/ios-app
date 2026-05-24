import SwiftUI

struct IosHomeIndicator: View {
    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        Capsule()
            .fill(wa.surfaceInvert)
            .frame(width: 140, height: 5)
            .padding(.top, 21)
            .padding(.bottom, 8)
    }
}
