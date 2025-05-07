import Foundation

public extension Vault.SecretEngines.IdentityClient {
    struct RoleRequest: Encodable, Sendable {
        public let key: String?
        public let template: String?
        public let clientId: String?
        public let timeToLive: String?
        
        public init(key: String?, template: String?, clientId: String?, timeToLive: String?) {
            self.key = key
            self.template = template
            self.clientId = clientId
            self.timeToLive = timeToLive
        }
        
        enum CodingKeys: String, CodingKey {
            case key
            case template
            case clientId = "client_id"
            case timeToLive = "ttl"
        }
    }
}
