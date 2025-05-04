import Foundation

public extension Vault.KeyValue {
    struct SecretMetadataRequest: Encodable {
        public let maxVersion: Int?
        public let isCheckAndSetRequired: Bool?
        public let deleteVersionAfter: String?
        public let customMetadata: [String: String]?
        
        init(maxVersion: Int?, isCheckAndSetRequired: Bool?, deleteVersionAfter: String?, customMetadata: [String: String]?) {
            self.maxVersion = maxVersion
            self.isCheckAndSetRequired = isCheckAndSetRequired
            self.deleteVersionAfter = deleteVersionAfter
            self.customMetadata = customMetadata
        }
        
        enum CodingKeys: String, CodingKey {
            case maxVersion = "max_versions"
            case isCheckAndSetRequired = "cas_required"
            case deleteVersionAfter = "delete_version_after"
            case customMetadata = "custom_metadata"
        }
    }
}
