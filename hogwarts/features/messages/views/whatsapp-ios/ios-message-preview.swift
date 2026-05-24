import SwiftUI

enum IosPreviewLeading {
    case checkRead, checkSent, voice, location, deleted
}

struct IosMessagePreview: View {
    let text: String
    let leading: IosPreviewLeading?
    let italic: Bool
    @Environment(\.whatsAppColors) private var wa

    init(text: String, leading: IosPreviewLeading? = nil, italic: Bool = false) {
        self.text = text
        self.leading = leading
        self.italic = italic
    }

    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            if let leading {
                leadingIcon(leading)
            }
            Text(text)
                .font(.system(size: 14))
                .italic(italic)
                .tracking(-0.14)
                .foregroundStyle(wa.textSecondary)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private func leadingIcon(_ kind: IosPreviewLeading) -> some View {
        switch kind {
        case .checkRead:
            IosCheckMark(read: true)
                .foregroundStyle(wa.textProduct)
                .frame(width: 19, height: 19)
        case .checkSent:
            IosCheckMark(read: false)
                .foregroundStyle(wa.textSecondary)
                .frame(width: 19, height: 19)
        case .voice:
            Image(systemName: "mic.fill")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(wa.textSecondary)
                .frame(width: 16, height: 16)
        case .location:
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(wa.textSecondary)
                .frame(width: 16, height: 16)
        case .deleted:
            Image(systemName: "nosign")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(wa.textSecondary)
                .frame(width: 16, height: 16)
        }
    }
}

/// Double-check glyph. `read=true` shows solid (for blue), `read=false` shows thinner.
struct IosCheckMark: View {
    let read: Bool

    var body: some View {
        Canvas { ctx, size in
            let w = size.width
            let h = size.height
            let strokeWidth: CGFloat = read ? 1.6 : 1.4

            var path1 = Path()
            path1.move(to: CGPoint(x: w * 0.04, y: h * 0.54))
            path1.addLine(to: CGPoint(x: w * 0.35, y: h * 0.82))
            path1.addLine(to: CGPoint(x: w * 0.72, y: h * 0.22))

            var path2 = Path()
            path2.move(to: CGPoint(x: w * 0.28, y: h * 0.54))
            path2.addLine(to: CGPoint(x: w * 0.55, y: h * 0.82))
            path2.addLine(to: CGPoint(x: w * 0.94, y: h * 0.22))

            let color = GraphicsContext.Shading.foreground
            ctx.stroke(path1, with: color, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
            ctx.stroke(path2, with: color, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
        }
    }
}
