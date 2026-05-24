import SwiftUI

struct IosInfoEncrypt: View {
    var prefix: String = "Your personal"
    var topic: String = "messages"
    var suffix: String = "are"
    @Environment(\.whatsAppColors) private var wa

    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Image(systemName: "lock.fill")
                .font(.system(size: 10))
                .foregroundStyle(wa.textSecondary)
                .frame(width: 12, height: 12)

            HStack(spacing: 2) {
                Text(prefix).foregroundStyle(wa.textSecondary)
                Text(topic).foregroundStyle(wa.textSecondary)
                Text(suffix).foregroundStyle(wa.textSecondary)
                Text("end-to-end encrypted").foregroundStyle(wa.textProduct)
            }
            .font(.system(size: 11))
        }
        .padding(.vertical, 1)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
