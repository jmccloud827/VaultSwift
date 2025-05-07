import Foundation

public extension Vault.SecretEngines.TransitClient {
    enum SignatureAlgorithm: String, Encodable, Sendable {
        case pss
        case pkcs1v15
    }
}
