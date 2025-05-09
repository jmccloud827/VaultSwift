import Foundation

public extension Vault.SecretEngines.KeyValueClient {
    struct Metadata: Decodable, Sendable {
        public let createdTime: String?
        public let customMetadata: [String: String]?
        public let deletedTime: String?
        public let destroyed: Bool
        public let version: Int
        
        enum CodingKeys: String, CodingKey {
            case createdTime = "created_time"
            case customMetadata = "custom_metadata"
            case deletedTime = "deletion_time"
            case destroyed
            case version
        }
    }
}
