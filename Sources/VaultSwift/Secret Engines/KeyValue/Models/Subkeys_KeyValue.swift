import Foundation

public extension Vault.SecretEngines.KeyValueClient {
    struct Subkeys: Decodable, Sendable {
        public let subkeys: [String: JSONAny]
        public let metadata: Metadata
        
        enum CodingKeys: String, CodingKey {
            case subkeys
            case metadata
        }
    }
}
