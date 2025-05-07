import Foundation

public extension Vault.SecretEngines.KeyValueClient {
    struct FullMetadata: Decodable, Sendable {
        public let isCheckAndSetRequired: Bool
        public let createdTime: Date
        public let currentVersion: Int
        public let customMetadata: [String: String]?
        public let deleteVersionAfter: String
        public let maxVersions: Int
        public let oldestVersion: Int
        public let updatedTime: Date
        public let versions: [String: CondensedMetadata]
        
        enum CodingKeys: String, CodingKey {
            case isCheckAndSetRequired = "cas_required"
            case createdTime = "created_time"
            case currentVersion = "current_version"
            case customMetadata = "custom_metadata"
            case deleteVersionAfter = "delete_version_after"
            case maxVersions = "max_versions"
            case oldestVersion = "oldest_version"
            case updatedTime = "updated_time"
            case versions
        }
    }
    
    struct CondensedMetadata: Decodable, Sendable {
        public let createdTime: Date
        public let deletedTime: Date
        public let destroyed: Bool
        
        enum CodingKeys: String, CodingKey {
            case createdTime = "created_time"
            case deletedTime = "deletion_time"
            case destroyed
        }
    }
}
