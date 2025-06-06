import Foundation

public extension Vault.SecretEngines.IdentityClient {
    struct Token: Decodable, Sendable {
        public let clientID: String?
        public let token: String?
        public let timeToLive: Int?
        
        enum CodingKeys: String, CodingKey {
            case clientID = "client_id"
            case token
            case timeToLive = "ttl"
        }
    }
}
