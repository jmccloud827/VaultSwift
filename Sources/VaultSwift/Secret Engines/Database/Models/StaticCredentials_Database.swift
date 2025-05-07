import Foundation

public extension Vault.SecretEngines.DatabaseClient {
    struct StaticCredentials: Decodable, Sendable {
        public let lastVaultRotation: String
        public let rotationPeriod: Int
        public let timeToLive: Int
        
        enum CodingKeys: String, CodingKey {
            case lastVaultRotation = "last_vault_rotation"
            case rotationPeriod = "rotation_period"
            case timeToLive = "ttl"
        }
    }
}
