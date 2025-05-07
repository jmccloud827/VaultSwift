import Foundation

public extension Vault.SecretEngines.KeyValueClient {
    struct ConfigModel: Codable, Sendable {
        public let isCheckAndSetRequired: Bool
        public let deleteVersionAfter: String
        public let maxVersions: Int
        
        public init(isCheckAndSetRequired: Bool, deleteVersionAfter: String, maxVersions: Int) {
            self.isCheckAndSetRequired = isCheckAndSetRequired
            self.deleteVersionAfter = deleteVersionAfter
            self.maxVersions = maxVersions
        }
        
        enum CodingKeys: String, CodingKey {
            case isCheckAndSetRequired = "cas_required"
            case deleteVersionAfter = "delete_version_after"
            case maxVersions = "max_versions"
        }
    }
}
