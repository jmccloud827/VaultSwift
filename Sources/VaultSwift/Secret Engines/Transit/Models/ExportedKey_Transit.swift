import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct ExportedKey<T: Decodable & Sendable>: Decodable, Sendable {
        public let keys: T?
        public let name: String?
        public let type: KeyType?
        
        enum CodingKeys: String, CodingKey {
            case keys
            case name
            case type
        }
    }
}
