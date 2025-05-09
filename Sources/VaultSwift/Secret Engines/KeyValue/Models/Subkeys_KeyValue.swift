import Foundation

public extension Vault.SecretEngines.KeyValueClient {
    struct Subkeys<T: Decodable & Sendable>: Decodable, Sendable {
        public let subkeys: T
        public let metadata: Metadata
        
        enum CodingKeys: String, CodingKey {
            case subkeys
            case metadata
        }
    }
}
