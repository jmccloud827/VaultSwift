import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct TrimEncryptionKeyRequest: Encodable, Sendable {
        public let minimumAvailableVersion: Int
        
        public init(minimumAvailableVersion: Int) {
            self.minimumAvailableVersion = minimumAvailableVersion
        }
        
        enum CodingKeys: String, CodingKey {
            case minimumAvailableVersion = "min_available_version"
        }
    }
}
