import Foundation

public extension Vault.SecretEngines.KeyManagementClient {
    struct Key<T: Decodable & Sendable>: Decodable, Sendable {
        public let deletionAllowed: Bool?
        public let keys: [String: T]?
        public let latestVersion: Int?
        public let minimumEnabledVersion: Int?
        public let name: String?
        public let type: String?
        
        enum CodingKeys: String, CodingKey {
            case deletionAllowed = "deletion_allowed"
            case keys
            case latestVersion = "latest_version"
            case minimumEnabledVersion = "min_enabled_version"
            case name
            case type
        }
    }
}
