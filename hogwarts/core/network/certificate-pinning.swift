import Foundation
import CryptoKit
import os

/// `URLSessionDelegate` that does SPKI-based certificate pinning when the
/// `TLS_PIN_SHA256_SET` Info.plist key is populated. With an empty set
/// (the default in Debug) the delegate falls back to the system default
/// trust — so dev builds against staging never break.
///
/// CORE-010. Mirrors Android's `OkHttp CertificatePinner` and is the iOS
/// half of the same defense: even if a CA is compromised, a forged cert
/// for `ed.databayt.org` won't validate because its SubjectPublicKeyInfo
/// SHA-256 won't match the pinned set.
///
/// Rotation runbook: when the cert (re-)issues with a new key, generate
/// the new SPKI hash with `openssl x509 -in cert.pem -pubkey -noout |
/// openssl pkey -pubin -outform DER | openssl dgst -sha256 -binary |
/// openssl enc -base64`, add it to `TLS_PIN_SHA256_SET` BEFORE the cert
/// flips on the server, then remove the old pin in the next release.
final class CertificatePinningDelegate: NSObject, URLSessionDelegate {

    /// Base64-encoded SHA-256 hashes of the pinned SubjectPublicKeyInfo.
    /// Empty array disables pinning (system trust only).
    private let pinnedSPKIHashes: Set<String>

    /// Hostnames the pin set applies to. Pinning only fires for matching
    /// hosts so third-party SDKs (Stripe, Google Sign-In) that connect to
    /// their own backends are not affected.
    private let pinnedHosts: Set<String>

    init(
        pinnedSPKIHashes: Set<String>? = nil,
        pinnedHosts: Set<String>? = nil
    ) {
        self.pinnedSPKIHashes = pinnedSPKIHashes ?? Self.loadPinSet()
        self.pinnedHosts = pinnedHosts ?? Self.loadPinnedHosts()
    }

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping @Sendable (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        let host = challenge.protectionSpace.host

        // Not a pinned host or no pins configured → defer to system trust.
        guard !pinnedSPKIHashes.isEmpty, pinnedHosts.contains(host) else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        // Walk the cert chain, hash each leaf's SubjectPublicKeyInfo,
        // accept the first match. Bail if none match — refuse the
        // connection rather than fall back to system trust (otherwise
        // pinning would be defeated by any compromised CA).
        // SecTrustCopyCertificateChain is the iOS 15+ replacement for
        // the deprecated SecTrustGetCertificateAtIndex loop.
        let chain = (SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate]) ?? []
        for cert in chain {
            guard let spkiHash = Self.spkiSHA256Base64(for: cert) else { continue }
            if pinnedSPKIHashes.contains(spkiHash) {
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
                return
            }
        }

        Logger.app.error("Certificate pinning rejected connection to \(host, privacy: .public)")
        completionHandler(.cancelAuthenticationChallenge, nil)
    }

    // MARK: - SPKI extraction

    private static func spkiSHA256Base64(for cert: SecCertificate) -> String? {
        guard let publicKey = SecCertificateCopyKey(cert),
              let externalRepresentation = SecKeyCopyExternalRepresentation(publicKey, nil) as Data?
        else { return nil }
        let hash = SHA256.hash(data: externalRepresentation)
        return Data(hash).base64EncodedString()
    }

    // MARK: - Config

    private static func loadPinSet() -> Set<String> {
        guard let raw = Bundle.main.object(forInfoDictionaryKey: "TLS_PIN_SHA256_SET") as? String else {
            return []
        }
        // Comma-separated to keep Info.plist simple; trim whitespace.
        return Set(
            raw.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
        )
    }

    private static func loadPinnedHosts() -> Set<String> {
        guard let raw = Bundle.main.object(forInfoDictionaryKey: "TLS_PIN_HOSTS") as? String else {
            // Sensible default — only the Hogwarts API host.
            return ["ed.databayt.org"]
        }
        return Set(
            raw.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
        )
    }
}
