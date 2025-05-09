import Foundation

public extension Vault.SecretEngines.IdentityClient {
    struct RoleRequest: Encodable, Sendable {
        public let key: String?
        public let template: String?
        public let clientID: String?
        public let timeToLive: String?
        
        public init(key: String?, template: String?, clientID: String?, timeToLive: String?) {
            self.key = key
            self.template = template
            self.clientID = clientID
            self.timeToLive = timeToLive
        }
        
        enum CodingKeys: String, CodingKey {
            case key
            case template
            case clientID = "client_id"
            case timeToLive = "ttl"
        }
    }
}
