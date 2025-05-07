import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct ExportedKey: Decodable, Sendable {
        public let keys: [String: JSONAny]?
        public let name: String?
        public let type: KeyType?
        
        enum CodingKeys: String, CodingKey {
            case keys
            case name
            case type
        }
    }
}
