import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct RestoreEncryptionKeyRequest: Encodable, Sendable {
        public let backupData: String
        public let force: Bool
        
        public init(backupData: String, force: Bool) {
            self.backupData = backupData
            self.force = force
        }
        
        enum CodingKeys: String, CodingKey {
            case backupData = "backup"
            case force
        }
    }
}
