import Foundation

public extension Vault.SecretEngines.ActiveDirectoryClient {
    struct RoleRequest: Encodable, Sendable {
        public let serviceAccountName: String
        public let timeToLive: Int
        
        init(serviceAccountName: String, timeToLive: Int) {
            self.serviceAccountName = serviceAccountName
            self.timeToLive = timeToLive
        }
        
        enum CodingKeys: String, CodingKey {
            case serviceAccountName = "service_account_name"
            case timeToLive = "ttl"
        }
    }
}
