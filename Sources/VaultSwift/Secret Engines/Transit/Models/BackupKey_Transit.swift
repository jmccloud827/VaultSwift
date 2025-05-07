import Foundation

public extension Vault.SecretEngines.TransitClient {
    struct BackupKeyResponse: Decodable, Sendable {
        public let backupData: String?
        
        enum CodingKeys: String, CodingKey {
            case backupData = "backup"
        }
    }
}
