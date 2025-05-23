import Foundation

public extension Vault.SecretEngines.PKIClient {
    enum CertificateFormat: String, Encodable, Sendable {
        case empty
        case der
        case pem
        case pemBundle = "pem_bundle"
        case json
    }
}
