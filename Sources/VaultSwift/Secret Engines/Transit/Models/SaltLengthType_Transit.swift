import Foundation

public extension Vault.SecretEngines.TransitClient {
    enum SaltLengthType: String, Encodable, Sendable {
        case auto
        case hash
    }
}
