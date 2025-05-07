import Foundation

public extension Vault.SecretEngines.OpenLDAPClient {
    struct StaticRoleCredentials: Decodable, Sendable {
        public let username: String?
        public let password: String?
        public let distinguishedName: String?
        public let lastVaultRotation: String?
        public let rotationPeriod: Int?
        public let timeToLive: Int?
        public let lastPassword: String?
        
        enum CodingKeys: String, CodingKey {
            case username
            case password
            case distinguishedName = "dn"
            case lastVaultRotation = "last_vault_rotation"
            case rotationPeriod = "rotation_period"
            case timeToLive = "ttl"
            case lastPassword = "last_password"
        }
    }
}
