import Foundation

public extension Vault.SecretEngines.TransitClient {
    enum HashFunctionType: String, Encodable, Sendable {
        case sha1
        case sha224
        case sha256
        case sha384
        case sha512
    }
}
