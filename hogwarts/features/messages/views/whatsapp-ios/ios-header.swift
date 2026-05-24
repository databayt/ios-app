import SwiftUI

struct IosHeader: View {
    var title: String? = nil
    var showOptions: Bool = true
    var showCamera: Bool = true
    var showAdd: Bool = true
    var showBack: Bool = false
    var onOptions: (() -> Void)? = nil
    var onCamera: (() -> Void)? = nil
    var onAdd: (() -> Void)? = nil
    var onBack: (() -> Void)? = nil

    @Environment(\.whatsAppColors) private var wa
    @Environment(\.layoutDirection) private var layoutDirection

    var body: some View {
        ZStack(alignment: .bottom) {
            wa.surfacePanelBlur
                .background(.ultraThinMaterial)
                .overlay(alignment: .bottom) {
                    Rectangle().fill(wa.borderPanel).frame(height: 0.33)
                }

            if showBack {
                Button(action: { onBack?() }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(wa.surfaceProduct)
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 4)
                .padding(.bottom, 8)
            }

            if let title {
                Text(title)
                    .font(.system(size: 16.8, weight: .semibold))
                    .tracking(-0.336)
                    .foregroundStyle(wa.textPrimary)
                    .padding(.bottom, 8)
            }

            HStack(spacing: 16) {
                if showOptions {
                    circularButton(action: { onOptions?() }, label: "More options") {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(wa.textPrimary)
                    }
                    Spacer()
                } else {
                    Spacer()
                }
                if showCamera {
                    circularButton(action: { onCamera?() }, label: "Camera") {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(wa.textPrimary)
                    }
                }
                if showAdd {
                    circularButton(action: { onAdd?() }, label: "New chat", product: true) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(wa.textInvert)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .frame(height: 98)
    }

    @ViewBuilder
    private func circularButton<V: View>(
        action: @escaping () -> Void,
        label: String,
        product: Bool = false,
        @ViewBuilder content: () -> V
    ) -> some View {
        Button(action: action) {
            content()
                .frame(width: 28, height: 28)
                .background(product ? wa.surfaceProduct : wa.surfaceCtaCircular)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}
