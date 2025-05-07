import Foundation

public extension Vault.SecretEngines.TransitClient {
    enum OutputEncodingFormat: String, Encodable, Sendable {
        case base64
        case hex
    }
}
