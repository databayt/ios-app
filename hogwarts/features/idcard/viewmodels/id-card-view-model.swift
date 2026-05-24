import Foundation
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

@MainActor
@Observable
final class IDCardViewModel {
    private(set) var card: IDCardResponse?
    private(set) var isLoading = false
    private(set) var lastError: String?

    private let actions: IDCardActions

    init(actions: IDCardActions = .init()) {
        self.actions = actions
    }

    func load() async {
        isLoading = true
        lastError = nil
        defer { isLoading = false }
        do {
            card = try await actions.fetch()
        } catch is CancellationError {
            // ignore
        } catch {
            lastError = error.localizedDescription
        }
    }

    /// Render the ID number as a Code 128 barcode. Returns nil when the
    /// number is missing or CoreImage produces no output (rare). Cached on
    /// the view model so the renderer doesn't fire on every redraw.
    private var cachedBarcode: (input: String, image: UIImage)?

    func barcodeImage(for input: String?, scale: CGFloat = 4) -> UIImage? {
        guard let input, !input.isEmpty else { return nil }
        if let cached = cachedBarcode, cached.input == input {
            return cached.image
        }

        let filter = CIFilter.code128BarcodeGenerator()
        filter.message = Data(input.utf8)
        filter.quietSpace = 8

        guard let outputImage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let scaled = outputImage.transformed(by: transform)

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        let uiImage = UIImage(cgImage: cgImage)
        cachedBarcode = (input, uiImage)
        return uiImage
    }
}
