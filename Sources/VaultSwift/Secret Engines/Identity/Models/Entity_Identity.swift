import Foundation

public extension Vault.Identity {
    struct Entity: Decodable, Sendable {
        public let id: String?
        public let name: String?
        public let metadata: [String: String]?
        public let policies: [String]?
        public let disabled: Bool
        public let aliases: [String]?
        public let bucketKeyHash: String?
        public let creationTime: Date?
        public let lastUpdateTime: Date?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case metadata
            case policies
            case disabled
            case aliases
            case bucketKeyHash = "bucket_key_hash"
            case creationTime = "creation_time"
            case lastUpdateTime = "last_update_time"
        }
    }
}
