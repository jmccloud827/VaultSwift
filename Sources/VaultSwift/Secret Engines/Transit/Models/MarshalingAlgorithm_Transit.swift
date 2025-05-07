import Foundation

public extension Vault.SecretEngines.TransitClient {
    enum MarshalingAlgorithm: String, Encodable, Sendable {
        case asn1
        case jws
    }
}
