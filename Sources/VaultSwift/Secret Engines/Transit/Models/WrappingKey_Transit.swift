import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct WrappingKey: Decodable, Sendable {
        public let publicKey: String?
        
        enum CodingKeys: String, CodingKey {
            case publicKey = "public_key"
        }
    }
}
