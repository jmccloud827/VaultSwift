import Foundation

public extension Vault.SecretEngines.IdentityClient {
    struct RoleResponse: Decodable, Sendable {
        public let data: Data
        
        enum CodingKeys: String, CodingKey {
            case data
        }
        
        public struct Data: Decodable, Sendable {
            public let key: String?
            public let template: String?
            public let clientID: String?
            public let timeToLive: String?
            
            enum CodingKeys: String, CodingKey {
                case key
                case template
                case clientID = "client_id"
                case timeToLive = "ttl"
            }
        }
    }
}
