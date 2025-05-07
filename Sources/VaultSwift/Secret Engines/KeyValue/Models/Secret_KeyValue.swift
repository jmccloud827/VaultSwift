import Foundation

public extension Vault.SecretEngines.KeyValueClient {
    struct Secret<T: Decodable & Sendable>: Decodable, Sendable {
        public let data: T
        public let metadata: Metadata
            
        enum CodingKeys: String, CodingKey {
            case data
            case metadata
        }
    }
}
