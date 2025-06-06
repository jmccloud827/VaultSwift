import Foundation

public extension Vault.SecretEngines.ActiveDirectoryClient {
    struct RoleResponse: Decodable, Sendable {
        public let lastVaultRotation: String?
        public let passwordLastSet: String?
        public let serviceAccountName: String?
        public let timeToLive: Int?
        
        enum CodingKeys: String, CodingKey {
            case lastVaultRotation = "last_vault_rotation"
            case passwordLastSet = "password_last_set"
            case serviceAccountName = "service_account_name"
            case timeToLive = "ttl"
        }
    }
}
